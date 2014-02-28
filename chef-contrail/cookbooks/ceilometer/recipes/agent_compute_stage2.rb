#
# Cookbook Name:: ceilometer
# Recipe:: ceilometer-agent-compute
#
# Copyright 2012, AT&T
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

include_recipe "ceilometer::common"
include_recipe "ceilometer::agent_common"

package "ceilometer-agent-compute"

# So ceilometer can read nova's config file.
execute "adduser ceilometer nova"

# So the libvirt agent can access the socket.
execute "adduser ceilometer libvirtd"

service "ceilometer-agent-compute" do
  service_name "ceilometer-agent-compute"
  action [:enable, :start]
end

# Only install stackmqbridge on zeromq installs
include_recipe "ceilometer::stackmqbridge" if node['openstack_config']['queue']['driver'] == 'zeromq'
