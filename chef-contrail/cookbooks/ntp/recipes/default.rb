#
# Cookbook Name:: ntp
# Recipe:: default
# Author:: Joseph Glanville (<joseph@cloudscaling.com>)
#
# Copyright 2009, Opscode, Inc
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

package "ntp"

service "ntp" do
  action :enable
end

is_server = OCS.node_has_service?(node, 'substratum')

zone = OCS.zone(1)
if is_server
  servers = zone['ntp_servers']
else
  servers = OCS.ips_for_service('substratum')
end
app_cidr = NetAddr::CIDR.create(zone['application_cidr'])

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[ntp]'
  variables({
    :servers => servers,
    :is_server => is_server,
    :app_cidr => app_cidr
  })
end
