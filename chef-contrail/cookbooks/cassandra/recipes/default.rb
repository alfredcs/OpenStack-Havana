# This will install Apache Cassandra and can be used to manage multiple clusters.

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

# Install the package.
package "cassandra"

# Define cassandra as a service.
service "cassandra" do
  supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
end

if !File.exist?("/var/lib/cassandra/.initial_config")
  service "cassandra" do
    action :stop
  end

  execute "wipe out initial data" do
    command "rm -rf /var/lib/cassandra/data; rm -rf /var/lib/cassandra/commitlog"
  end

  file "/var/lib/cassandra/.initial_config" do
    action :create
  end

end

#JNA and MX4J should be installed eventually

# Setup cassandra.
node['cassandra']['data_file_directories'].each do |d|
  directory d do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    recursive true
    action :create
  end
end

directory node['cassandra']['commitlog_directory'] do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  recursive true
  action :create
end

directory node['cassandra']['saved_caches_directory'] do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  recursive true
  action :create
end

template "/etc/cassandra/cassandra-env.sh" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  source "cassandra-env.sh.erb"
  notifies :restart, "service[cassandra]"
end

nodes = OCS.ips_for_service('cassandra')
app_ip = OCS.app_ip(node)

# File is automatically reloaded every 60s
template "/etc/cassandra/cassandra-topology.properties" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  variables({
    :nodes => nodes
  })
end

template "/etc/cassandra/cassandra.yaml" do
  owner "cassandra"
  group "cassandra"
  mode "0755"
  variables({
    :nodes => nodes,
    :initial_token => nodes.index(app_ip) * (2**127/nodes.count)
  })
  notifies :restart, "service[cassandra]"
end

service "cassandra" do
  action [:start, :enable]
end
