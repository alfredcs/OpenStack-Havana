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

package "logstash"

# Define logstash as a service.
service "logstash" do
  provider Chef::Provider::Service::Upstart
  action [:start, :enable]
end

rabbitmq_vhost node['logstash']['rabbitmq_vhost'] do
  action :add
end

rabbitmq_user node['logstash']['rabbitmq_user'] do
  password node['logstash']['rabbitmq_pass']
  vhost node['logstash']['rabbitmq_vhost']
  permissions "\".*\" \".*\" \".*\""
  action [:add, :update_password, :set_permissions]
end

%w[elasticsearch rabbitmq filters].each do |conf|
  template "/etc/logstash/conf.d/#{conf}.conf" do
    source "#{conf}.conf.erb"
    mode 0644
    notifies :restart, 'service[logstash]'
  end
end

directory "/etc/logstash/patterns"

%w[extras defaults].each do |pattern|
  cookbook_file "/etc/logstash/patterns/#{pattern}" do
    source pattern
    mode 0644
    notifies :restart, 'service[logstash]'
  end
end
