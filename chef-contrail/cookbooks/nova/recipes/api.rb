#
# Cookbook Name:: nova
# Recipe:: api
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

require 'chef/shell_out'

include_recipe "nova::base"
include_recipe "nova::config"

%w{ nova-api nova-doc }.each do |pkg|
  package pkg
end

ip_table_rule = "iptables -t nat -A PREROUTING -d 169.254.169.254/32 " +
  "-p tcp -m tcp --dport 80 -j DNAT --to-destination " +
  "#{node['openstack_config']['metadata_listen']}:8775"

execute ip_table_rule do
  # sed makes sure the rule is where it should be,
  # grep makes sure sed returned something (sed won't exit 1)
  not_if "iptables -t nat -L -n | sed -n '/Chain PREROUTING/,/Chain/{ /169.254.169.254/p; };' | grep 169.254.169.254"
end

# make sure that we run the iptables rule on reboot
execute "sed -i 's%exit 0%#{ip_table_rule}%' /etc/rc.local"

#api-paste
template "/etc/nova/api-paste.ini" do
  source "api-paste.ini.erb"
  owner "nova"
  group "nova"
  mode "0440"
end

cookbook_file "/etc/init/nova-api.conf" do
  source "nova-api.conf"
end

service "nova-api" do
  provider Chef::Provider::Service::Upstart
  action :restart
end
