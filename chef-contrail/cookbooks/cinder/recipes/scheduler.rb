#
# Cookbook Name:: cinder
# Recipe:: volume
#
# Copyright 2012, Cloudscaling, Inc.
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

#
# AAR - we will have our own scheduler for cinder; this is mostly a placeholder for that. Install default
#       scheduler for now.
#

include_recipe "cinder::base"
include_recipe "openstack_config::queue"

package "cs-volume-driver"
package "cinder-scheduler"

service "cinder-scheduler" do
  provider Chef::Provider::Service::Upstart
  action [:restart, :enable]
end
