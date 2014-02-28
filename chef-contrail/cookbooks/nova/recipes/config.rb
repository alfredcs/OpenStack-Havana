#
# Cookbook Name:: nova
# Recipe:: config
#
# Copyright 2010, 2011 Opscode, Inc.
# Copyright 2011 Dell, Inc.
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

include_recipe "nova::base"
include_recipe "openstack_config::queue"

include_recipe "openstack_config::sqlalchemy"

rpc_backend = node['openstack_config']['queue']['modules'][
    node['openstack_config']['queue']['driver']
  ] % { :project => "nova" }

template "/etc/nova/nova.conf" do
  source "nova.conf.erb"
  owner "nova"
  group "nova"
  variables({
    :rpc_backend => rpc_backend,
    :memcached_servers => OCS.ips_for_service('memcached').map {|ip| "#{ip}:#{node['memcached']['port']}"}.join(',')
  })
  mode 0640
end

template "/etc/nova/logging.conf" do
  source "logging.conf.erb"
  owner "nova"
  group "nova"
  mode 0640
end
