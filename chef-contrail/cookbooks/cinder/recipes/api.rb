#
# Cookbook Name:: cinder
# Recipe:: api
#
# Copyright 2010-2011, Opscode, Inc.
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

include_recipe "cinder::base"

package "cinder-api"

template "/etc/cinder/api-paste.ini" do
  owner "cinder"
  group "cinder"
  mode  0640
end

file "/etc/init/cinder-api.override" do
  action :delete
end

execute "cinder-db-sync" do
  user "root"
  command "cinder-manage db sync"
  retries 5
end

service "cinder-api" do
  provider Chef::Provider::Service::Upstart
  action [:restart, :enable]
end
