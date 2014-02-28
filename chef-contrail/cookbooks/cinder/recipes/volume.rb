#
# Cookbook Name:: cinder
# Recipe:: volume
#
# Copyright 2012, Cloudscaling, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "mysql::client"
include_recipe "openstack_config::queue"
include_recipe "cinder::base"

package "cinder-volume"
package "cinder-backup"
package "cs-volume-driver"
package "python-argh"
package "python-snappy"

file "/etc/init/tgt.override" do
  content "manual"
  mode 0644
end

service 'tgt' do
  action :stop
end

package 'targetcli'
package 'python-rtslib-fb'
package 'python-rtstool'
# We don't actually us this but it sets the initator name required by LIO
package 'open-iscsi'

execute "add-configfs-fstab-entry" do
  command "echo configfs /sys/kernel/config configfs defaults 0 0 >> /etc/fstab"
  not_if "grep configfs /etc/fstab"
end

execute "mount-configfs" do
  command "mount configfs"
  not_if "grep configfs /proc/mounts"
end

cookbook_file '/etc/sudoers.d/cinder_sudoers' do
  source 'cinder_sudoers'
  mode 0440
end

cookbook_file '/etc/cinder/rootwrap.d/zfs.filters' do
  source 'zfs.filters'
  mode 0440
end

template '/etc/cinder/zfs2swift.conf' do
  source 'zfs2swift.conf.erb'
  mode 0440
  owner 'cinder'
  group 'cinder'
end

service "cinder-volume" do
  provider Chef::Provider::Service::Upstart
  action [:restart, :enable]
end

service "cinder-backup" do
  provider Chef::Provider::Service::Upstart
  action [:restart, :enable]
end
