#
# Cookbook Name:: nova
# Recipe:: compute
#
# Copyright 2010-2011, Opscode, Inc.
# Copyright 2011, Dell, Inc.
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

require 'chef/shell_out'

# Ubuntu included for sysctl mangling
include_recipe "ubuntu::default"

include_recipe "mysql::client"
include_recipe "nova::base"
include_recipe "nova::config"
include_recipe "nova::tools"
include_recipe "openstack_config::queue"

package 'pm-utils'
package 'open-iscsi'

service 'open-iscsi' do
  action [:start, :enable]
end

cmd = Chef::ShellOut.new("lsmod")
modules = cmd.run_command
Chef::Log.debug modules

execute "modprobe nbd" do
  action :run
  not_if {modules.stdout.include?("nbd")}
end

package "nova-compute-kvm" do
  options "-o Dpkg::Options::='--force-confnew'"
end

# Block
blocked = [
  node['management_cidr'],
  node['application_cidr'],
  node['hardware_cidr']
].join(',')

if node['haproxy'].has_key?('https_api_hostname')
  api_ip = node['haproxy']['https_listener_ip']
else
  api_ip = OCS.app_ecmp_ip
end

if node['haproxy'].has_key?('https_s3_hostname')
  s3_ip = node['haproxy']['https_s3_ip']
else
  s3_ip = OCS.app_ecmp_ip
end

whitelisted = [
  "#{api_ip}:#{node['glance']['api_bind_port']}", # Glance
  "#{api_ip}:#{node['nova']['novncproxy']['port']}", # Nova
  "#{api_ip}:8873", # Nova
  "#{api_ip}:8874", # Nova
  "#{api_ip}:8875", # Nova
  "#{api_ip}:8777", # Ceilometer
  "#{api_ip}:9696", # Quantum
  "#{api_ip}:#{node['openstack_config']['cinder']['server_port']}", # Cinder
  "#{api_ip}:#{node['heat']['api_bind_port']}", # Heat
  "#{api_ip}:#{node['heat']['api_cfn_bind_port']}", # Heat Cloudformation
  "#{api_ip}:#{node['heat']['api_cloudwatch_bind_port']}", # Heat Cloudwatch
  "#{api_ip}:443", # Horizon SSL
  "#{api_ip}:5000", # Keystone
  "#{api_ip}:35357", # Keystone Admin
  "#{s3_ip}:80", # S3
  "#{s3_ip}:443" # S3 SSL
].join(',')

template '/etc/nova/nova-compute.conf' do
  mode 0644
  variables({
    :blocked_networks => blocked,
    :whitelisted_hosts => whitelisted
  })
end

cookbook_file '/etc/libvirt/qemu.conf' do
  source 'qemu.conf'
end

service 'libvirt-bin' do
  action :restart
end

execute "cleanup virtual nat" do
  command "virsh net-destroy default && virsh net-undefine default"
  only_if "virsh net-list | grep default"
  #notifies :restart, resources(:service => "libvirt-bin"), :immediately
end

cookbook_file "/etc/nova/rootwrap.d/l3manager.filters" do
  source "l3manager.filters"
  owner "root"
  group "root"
  mode 0644
  only_if {node['nova']['network'] == "Layer3Manager"}
end

cookbook_file "/etc/init/nova-compute.conf" do
  source "nova-compute.conf"
  mode 0644
end

service "nova-compute" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, 'template[/etc/nova/nova.conf]', :delayed
end

cookbook_file "/etc/sysctl.d/61-nova-swappiness.conf" do
  source "61-nova-swappiness.conf.sysctl"
  owner "root"
  group "root"
  mode 0644
  notifies :start, 'service[procps]', :immediately
end

cookbook_file "/etc/init/nova-save.conf" do
    source "nova-save.conf"
    mode 0644
end

cookbook_file "/etc/init/nova-restore.conf" do
    source "nova-restore.conf"
    mode 0644
end

cookbook_file "/etc/init/nova-save.py" do
    source "nova-save.py"
    mode 0755
end

cookbook_file "/etc/init/nova-restore.py" do
    source "nova-restore.py"
    mode 0755
end

beaver_log "libvirtd" do
  file "/var/log/libvirt/libvirtd.log"
  type "libvirt"
end
