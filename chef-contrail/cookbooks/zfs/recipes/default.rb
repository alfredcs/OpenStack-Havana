#
# Cookbook Name:: zfs
# Recipe:: default
#
# Copyright 2013, Cloudscaling
#
#

package "linux-headers-#{node['kernel']['release']}"
package "ubuntu-zfs"

if node['sas_enclosures']
  node['sas_disks'] = SAS.enumerate_enclosure_disks(node['sas_enclosures'])
end

ruby_block "create-zfs-pools" do
  block do
    node['zfs_pools'].each do |pool, layout|
      if !ZFS.import_pool(pool)
        if layout.has_key?('autogen') && layout['autogen'] == 'true'
          ssd_pool = layout.has_key?('ssd_pool') ? layout['ssd_pool'] : false
          datasets = layout.has_key?('datasets') ? layout['datasets'] : {}
          pool = ZFS.autogen_pool(node['partitions'], datasets, [], ssd_pool)
          ZFS.build_pool('epool', pool, nil)
        else
          ZFS.validate_devs(layout, node['sas_disks'])
          ZFS.build_pool(pool, layout, node['sas_disks'])
        end
      end
    end
  end
end

template '/etc/modprobe.d/zfs.conf' do
  source 'zfs.conf.erb'
end

ruby_block "apply-zfs-parameters" do
    block do
        node['zfs']['options'].each do |option, value|
            path = "/sys/module/zfs/parameters/#{option}"
            open(path, 'w') {|f| f.write(value)}
        end
    end
end
