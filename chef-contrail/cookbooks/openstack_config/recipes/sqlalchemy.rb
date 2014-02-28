#
# Cookbook Name:: openstack_config
# Recipe:: sqlalchemy
#
# Copyright 2012, The Cloudscaling Group, Inc.
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

if node['openstack_config']['sqlalchemy']['driver'] == "mysql+pymysql"
  package python-pip
  execute "pip install pymysql"
elsif node['openstack_config']['sqlalchemy']['driver'] == "mysql"
  package "python-mysqldb"
end
