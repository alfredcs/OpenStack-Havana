#
# Cookbook Name:: swift
# Recipe:: object_server
#
# Copyright 2010-2011, Cloudscaling
#
# This recipe will configure a node to be a swift object server.
# More specifically, it will install the primary and secondary
# services listed in the node['swift']['object_server']['servers'] and
# node['swift']['object_server']['secondary_servers'] data objects which are
# specified in attributes/object_server.rb


# make sure that we run swift::default
include_recipe 'swift'

package 'swift-account'
package 'swift-container'
package 'swift-object'

devices = OCS::BlkDev.unused_devices(OCS.machine(node.id)['partitions'])['block_devices']
swift_devices = devices.map { |drive| "/dev/#{drive}" }.sort
if OCS.node_has_service?(node,'swift_object_server')
    OCS.update_self(node, {:swift => {:object_server => { :storage_devices => swift_devices }}})
end
dev_map = Hash[swift_devices.each_with_index.map do |dev, idx|
    [dev, "D#{sprintf '%03d', idx}"]
end]

cookbook_file '/etc/init.d/mount-jbod' do
  mode 0744
  source 'mount-jbod'
end

service 'mount-jbod' do
  action :enable
end

# Wait for any outstanding mkfs jobs to complete before running a bunch
# of new mkfs jobs, since we're going to key on `pgrep mkfs`.  There
# really shouldn't be any mkfs jobs running at this time, but...
execute "Wait outstanding/unrelated mkfs jobs to complete (there should be none)" do
  command <<-EOF
    while ! [ -z "$(pgrep mkfs)" ]; do
      echo -n "."
      sleep 1
    done
    echo 'clear'
  EOF
end

dev_map.each do |dev,label|
  # format the device but only if it exists and is not mounted
  # do them all in parallel because sequential is slow
  execute "format #{dev}" do
     # setsid so background procs don't confuse chef
     command "setsid mkfs.xfs -i size=1024 -f -L #{label} #{dev} &"
     only_if "test -b #{dev} && ! mount | grep -E '#{dev}\s'"
  end
end

# Wait for all mkfs processes to complete, then sync (because baby 
# filesystems need care) and wait a moment for things to simmer down.
# This is more interesting when we format a large number of devices.
execute "Wait for devices to finish formatting" do
  command <<-EOF
    while ! [ -z "$(pgrep mkfs)" ]; do
      echo -n "."
      sleep 1
    done
    echo -n ' formatting completed, syncing: '
    sync
    sync
    sleep 5
    echo 'done'
  EOF
end

dev_map.each do |dev,label|
  mount_point = "/srv/node/#{label}"
  directory mount_point do
      owner node['swift']['user']
      group node['swift']['group']
      mode 0755
      recursive true
  end
  execute "chown -R #{node['swift']['user']}:#{node['swift']['user']} #{mount_point}"
end

template '/etc/swift/disk.conf' do
  source 'disk.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables({
    :labels => dev_map.map {|dev, label| label }.join(' '),
    :opts => 'noatime'
  })
  notifies :start, 'service[mount-jbod]', :immediately
end

workers = swift_devices.length
%w{object account container}.each do |service|
  template "/etc/swift/#{service}-server.conf" do
    source 'swift-server.conf.erb'
    owner node['swift']['user']
    group node['swift']['group']
    variables({
      :type => service,
      :workers => workers
    })
  end
end
