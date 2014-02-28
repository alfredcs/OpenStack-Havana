#
# Cookbook Name:: heat
# Recipe:: base
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe "heat::mysql"

package "heat-common"

user "heat" do
  shell "/bin/bash"
end

node.set_unless['heat']['auth_encryption_key'] = secure_password + '1234'

cookbook_file "/etc/heat/policy.json" do
  source "policy.json"
  owner node['heat']['user']
  group node['heat']['group']
  mode  0640
end

template "/etc/heat/heat.conf" do
  source "heat.conf.erb"
  owner "heat"
  group "heat"
  mode "0440"
end
