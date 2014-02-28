#
# ZFS pool and dataset creation
# Copyright Cloudscaling
# Author: Joseph Glanville <joseph@cloudscaling.com>
#

require_relative './blk'

class ZFSInvalidConfigurationError < StandardError
end

class ZFSPoolCreationError < StandardError
end

module ZFS

  def self.validate_devs(pool, enum_disks)
    pool.each_value do |section|
      if ['vdevs', 'logs','cache'].include? section
        section.each do |vdev|
          if vdev['dev'] == 'enclosure'
            if !enum_disks.has_key? vdev['enclosure']
              raise ZFSInvalidConfigurationError "Enclosure not present: #{vdev['enclosure']}"
            end
          else
            if !File.exist? "/dev/#{vdev['dev']}"
              raise ZFSInvalidConfigurationError "Device or partition does not exist: #{vdev['dev']}"
            end
          end
        end
      end
    end
  end

  def self.build_vdev(vdev, enum_disks)
    t = vdev['type']
    if t.include? 'raidz' or t == 'mirror'
      # Multiple dev logic
      if vdev.has_key? 'enclosure'
        e = vdev['enclosure']
        return [vdev['type']] + vdev['drives'].map {|d| enum_disks[e][d]}
      elsif vdev['dev'].kind_of?(Array)
        return [vdev['type']] + vdev['dev']
      else
        raise ZFSInvalidConfigurationError "Bad vdev specification: #{vdev}"
      end
    elsif t == 'raw'
      return [vdev['dev']]
    end
  end

  def self.set_options(name, options)
    options.each do |opt, val|
      system('zfs','set',"#{opt}=#{val}", name)
    end
  end

  def self.create_dataset(dataset, options)
    system('zfs','create', dataset)
    set_options(dataset, options)
  end

  def self.build_pool(name, pool, enum_disks)
    args = ['zpool','create','-f', name]
    ['vdevs','cache','log'].each do |section|
      if pool.has_key?(section)
        vdevs = pool[section].map {|vdev| build_vdev(vdev, enum_disks)}
        vdevs.unshift(section) unless section == 'vdevs' || vdevs.empty?
        args += vdevs
      elsif section == 'vdevs'
        # Fall through here is fatal pool must contain vdevs
        raise ZFSInvalidConfigurationError "Invalid pool config: vdevs is required"
      end
    end
    # Actually run the cmd
    raise ZFSPoolCreationError unless system(*args.flatten)
    if pool.has_key? 'options'
      set_options(name, pool['options'])
    end
    if pool.has_key? 'datasets'
      pool['datasets'].each do |dataset, opts|
        create_dataset("#{name}/#{dataset}", opts)
      end
    end
  end

  def self.import_pool(pool)
    if system('zpool','list', pool)
      return true
    else
      system('zpool','import','-f', pool)
    end
  end

  def self.autogen_pool(partition_map, datasets=[], options=[], ssd_pool=false)
    available = OCS::BlkDev.unused_devices(partition_map)
    whole = available['block_devices']
    parts = available['partitions']

    # cbf dealing with non-SSD partitions, they are no good for anything
    spinning = whole.select {|d| OCS::BlkDev.rotational?(d)}
    whole_ssds = whole - spinning
    ssd_partitions = parts.reject {|d| OCS::BlkDev.rotational?(d)}
    pool_devs = []
    cache_devs = []
    log_devs = []

    # if the pool is made out of ssds then ZIL/L2arc don't make _much_ sense
    if ssd_pool
      pool_devs += whole_ssds
    else
      if whole_ssds.count == 1
        # priortize the log
        log_devs << {'dev' => whole_ssds.pop, 'type' => 'raw'}
      elsif whole_ssds.count == 2
        # we can use whole devices for both log and cache yay
        log_devs << {'dev' => whole_ssds.pop, 'type' => 'raw'}
        cache_devs << {'dev' => whole_ssds.pop, 'type' => 'raw'}
      elsif whole_ssds.count > 2
        # we have enough for a mirrored ZIL!
        log_devs << {'dev' => whole_ssds.slice(0,2), 'type' => 'mirror'}
        cache_devs += whole_ssds.slice(2,whole_ssds.count).map {|d| {'dev' => d, 'type' => 'raw'}}
      end
      pool_devs += spinning
    end
    if log_devs.count < 1 && ssd_partitions.count > 0
      # make a log from an ssd_partition (gross...)
      log_devs << {'dev' => ssd_partitions.pop, 'type' => 'raw'}
    end
    if ssd_partitions.count > 0 && !ssd_pool # don't make the pool slower for no good reason
      # use the left overs as cache
      cache_devs += ssd_partitions.map {|d| {'dev' => d, 'type' => 'raw'}}
    end
    sizes = {}
    pool_devs.each {|d| (sizes[OCS::BlkDev.size(d)] ||= []) << d}
    vdevs = []
    sizes.each do |size, devs|
      if devs.count % 10 == 0
        divisor = 10
        type = 'raidz2'
      elsif devs.count % 9 == 0
        divisor = 9
        type = 'raidz'
      elsif devs.count % 6 == 0
        divisor = 6
        type = 'raidz2'
      elsif devs.count % 5 == 0
        divisor = 5
        type = 'raidz'
      elsif devs.count % 4 == 0
        divisor = 4
        type = 'raidz2'
      elsif devs.count % 3 == 0
        divisor = 3
        type = 'raidz'
      elsif devs.count % 2 == 0
        divisor = 2
        type = 'mirror'
      else
        type = 'raw'
      end
      if divisor
        chunks = devs.each_slice(divisor).to_a
        vdevs += chunks.map {|c| {'dev' => c, 'type' => type}}
      else
        vdevs += [{'dev' => devs.first, 'type' => type }]
      end
    end
    # the finished zpool
    {
      'vdevs' => vdevs,
      'cache' => cache_devs,
      'log' => log_devs,
      'datasets' => datasets,
      'options' => options
    }
  end

end
