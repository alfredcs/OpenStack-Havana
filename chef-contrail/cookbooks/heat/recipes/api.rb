#
# Cookbook Name:: heat
# Recipe:: api
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


include_recipe "heat::base"

package "heat-api"

cookbook_file "/etc/heat/api-paste.ini" do
  source "api-paste.ini"
  owner node['heat']['user']
  group node['heat']['group']
  mode  0640
end

file "/etc/init/heat-api.override" do
  action :delete
end

execute "heat-db-sync" do
  user "heat"
  command "heat-manage db_sync"
  retries 1
end

service "heat-api" do
  provider Chef::Provider::Service::Upstart
  action [:restart, :enable]
end
