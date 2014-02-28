#
# Cookbook Name:: heat
# Recipe:: engine
#
# Copyright 2014, Cloudscaling, Inc.
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

include_recipe "heat::base"

package "heat-engine"

directory "/etc/heat/environment.d" do
  owner node['heat']['user']
  group node['heat']['group']
  mode "0755"
  action :create
end

cookbook_file "/etc/heat/environment.d/default.yaml" do
  source "default.yaml"
  owner node['heat']['user']
  group node['heat']['group']
  mode  0640
end

service "heat-engine" do
  provider Chef::Provider::Service::Upstart
  action [:restart, :enable]
end
