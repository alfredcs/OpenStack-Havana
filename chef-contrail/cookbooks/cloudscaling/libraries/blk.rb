#
# OCS Module for working with block devices
# Copyright Cloudscaling
# Author: Joseph Glanville <joseph@cloudscaling.com>
#

# partition_map JSON example:
#  "partitions": [
#                 {
#      "mount_point": "swap",
#      "size": "256MB",
#      "fs_type": "swap",
#      "dev": "/dev/sda",
#      "partition": 1
#                 },
#                 {
#      "mount_point": "/",
#      "size": "use_remainder",
#      "fs_type": "xfs",
#      "dev": "/dev/sda",
#      "partition": 2
#                 }
#  ],
#
# Note that partition_map represents the array value for the key "partitions"
#
module OCS
  module BlkDev
    class << self
      def used_devices(partition_map)
        fs_partitions = partition_map.reject { |p| p['fs_type'] == 'none' }
        root_partition_hsh = fs_partitions.find { |p| p['mount_point'] == '/' }
        grub_dev = File.basename root_partition_hsh['dev']
        # to make miniboot happy, we are going to make the grub_dev own the
        # first partition, and bump every other partition on the same device
        # up by 1
        fs_partitions.map { |p|
          dev = File.basename p['dev']
          part = dev == grub_dev ? p['partition'] + 1 : p['partition']
          "#{dev}#{part}"
        } << "#{grub_dev}1"
      end

      def unused_devices(partition_map)
        all_blk_devs = Dir.entries('/sys/class/block').select do |b|
          b.start_with?('sd') || b.start_with?('vd')
        end
        whole_devs = all_blk_devs.select {|b| /^[a-zA-Z]*$/.match(b)}
        partitions = all_blk_devs.select {|b| /^[a-zA-Z]*[0-9]$/.match(b)}
        used_partitions = self.used_devices(partition_map)
        devs_with_partitions = used_partitions.map {|p| p.tr('0-9', '')}.uniq

        free_block_devs = whole_devs - devs_with_partitions
        free_partitions = (partitions - used_partitions).reject do |p|
          free_block_devs.include? p.tr('0-9', '')
        end
        {'block_devices' => free_block_devs, 'partitions' => free_partitions}
      end

      def rotational?(blk_dev)
        disk = blk_dev.tr('0-9', '')
        File.read("/sys/block/#{disk}/queue/rotational").strip.to_i == 1
      end

      def size(blk_dev)
        File.read("/sys/block/#{blk_dev}/size").strip.to_i
      end

      # accept e.g. sda1 or /dev/sda1
      # check for exact match on first field of /etc/mtab
      #
      def mounted?(device_name_or_path)
        device_list = `cut -d' ' -f1 /etc/mtab`.split("\n")
        # did they pass in e.g. /dev/sda1 ?
        if File.blockdev?(device_name_or_path)
          device_list.include? device_name_or_path
        else
          candidate = File.join('/dev', device_name_or_path)
          if File.blockdev?(candidate)
            # passed in e.g. sda1
            device_list.include? candidate
          end
        end
      end
    end
  end
end
