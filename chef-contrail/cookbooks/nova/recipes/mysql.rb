#
# Cookbook Name:: nova
# Recipe:: mysql
#
# Copyright 2010-2011, Opscode, Inc.
# Copyright 2011, Dell, Inc.
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
include_recipe "build-essential"
include_recipe "nova::config"
include_recipe "mysql::server"

grant "nova" do
    user node['nova']['mysql']['user']
    database node['nova']['mysql']['database']
    password node['nova']['mysql']['password']
end

execute "dont-populate-default-instances" do
  command "sed -i 's/_populate_instance_types(instance_types)/#_populate_instance_types(instance_types)/g' /usr/lib/python2.7/dist-packages/nova/db/sqlalchemy/migrate_repo/versions/133_folsom.py"
end

execute "nova-manage db sync" do
  user node['nova']['user']
  retries 5
end
