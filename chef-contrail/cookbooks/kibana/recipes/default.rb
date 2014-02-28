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

include_recipe "apache2"

package 'kibana'

directory node['kibana']['log_dir']

service 'apache2' do
  action :nothing
end

execute "enable-mod_proxy" do
  command "a2enmod proxy"
  notifies :restart, 'service[apache2]', :delayed
end

execute "chown -R www-data:www-data #{node['kibana']['web_dir']}"

cookbook_file "#{node['kibana']['web_dir']}app/dashboards/default.json" do
  source 'default.json'
  user 'www-data'
  group 'www-data'
  mode 0644
end

template '/etc/apache2/conf.d/kibana.conf' do
  source 'kibana.conf.erb'
  mode 0644
  notifies :reload, 'service[apache2]', :delayed
end
