#
# Cookbook Name::       redis
# Description::         Redis server  
# Recipe::              server
# Author::              Benjamin Black
#
# Copyright 2011, Benjamin Black
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

['conf_dir', 'log_dir', 'data_dir'].each do |dir|
  directory node['redis'][dir] do
    user 'redis'
    group 'redis'
    mode '0755'
  end
end

include_recipe "redis::base"

service "redis-server" do
  action [:enable, :start]
end
