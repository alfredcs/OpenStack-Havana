#
# Cookbook Name:: nova
# Recipe:: network
#
# Copyright 2010-2011, Opscode, Inc.
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

# Ubuntu included for sysctl mangling
include_recipe "ubuntu::default"

include_recipe "nova::base"
include_recipe "nova::config"
include_recipe "openstack_config::queue"
include_recipe "mysql::client"

%w{ nova-network nova-doc }.each do |pkg|
  package pkg
end

service "nova-network" do
  status_command "status nova-network | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
  supports :status => true, :restart => true
  action [:enable, :start]
end

#intercepts restarts for nova-network
execute "killall dnsmasq" do
  returns [0, 1]
  subscribes :run, 'template[/etc/nova/nova.conf]'
  #notifies :restart, 'service[nova-network]', :immediately
end

#enable ipv4 forwarding
execute "sysctl -p" do
  user "root"
  action :nothing
end

cookbook_file "/etc/sysctl.d/61-nova-swappiness.conf" do
  source "61-nova-swappiness.conf.sysctl"
  owner "root"
  group "root"
  mode 0644
  notifies :run, 'execute[sysctl -p]', :immediately
end
