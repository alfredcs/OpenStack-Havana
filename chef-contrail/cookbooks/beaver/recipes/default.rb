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

package 'python-glob2'
package 'python-beaver'

template '/etc/init/beaver.conf' do
  source 'beaver.conf.erb'
  mode 0644
end

service 'beaver' do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

directory "/etc/beaver"
directory "/etc/beaver/conf.d"

template node['beaver']['config_file'] do
  source 'conf.erb'
  mode 0644
  notifies :restart, 'service[beaver]', :immediately
end
