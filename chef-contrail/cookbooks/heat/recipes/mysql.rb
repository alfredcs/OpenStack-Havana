#
# Cookbook Name:: heat
# Recipe:: mysql
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
# To get the "grant" method only, don't install a server wherever this is used.
include_recipe "mysql::client"

grant "heat" do
  user node['heat']['mysql']['user']
  database node['heat']['mysql']['database']
  password node['heat']['mysql']['password']
end
