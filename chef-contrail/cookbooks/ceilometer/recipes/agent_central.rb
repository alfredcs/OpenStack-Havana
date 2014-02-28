#
# Cookbook Name:: ceilometer
# Recipe:: ceilometer-agent-central
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

package "ceilometer-agent-central"

service "ceilometer-agent-central" do
  service_name "ceilometer-agent-central"
  action [:enable, :start]
end
