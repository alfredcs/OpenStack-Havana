# This will install Apache Zookeeper.

# Copyright 2013, Cloudscaling.
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

package "zookeeper"
package "zookeeper-bin"
package "zookeeperd"

service "zookeeper" do
  supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
end

link "/etc/zookeeper/conf" do
  action :delete
  only_if "test -L /etc/zookeeper/conf"
end

conf_dir = node['zookeeper']['conf_dir']

directory conf_dir

servers = OCS.ips_for_service('zookeeper')
app_ip = OCS.app_ip(node)
my_id = servers.index(app_ip)

file "#{conf_dir}/myid" do
  content my_id
  mode 0644
  notifies :restart, "service[zookeeper]"
end

template "#{conf_dir}/zoo.cfg" do
  source "zoo.cfg.erb"
  mode 0644
  variables({
    :servers => servers,
    :bind_address => app_ip
  })
  notifies :restart, "service[zookeeper]"
end

template "#{conf_dir}/environment" do
  source "environment.erb"
  mode 0644
  notifies :restart, "service[zookeeper]"
end

template "#{conf_dir}/log4j.properties" do
  source "log4j.properties.erb"
  mode 0644
  notifies :restart, "service[zookeeper]"
end

cookbook_file "#{conf_dir}/configuration.xsl" do
  source "configuration.xsl"
  mode 0644
end

service "zookeeper" do
  action [:start, :enable]
end
