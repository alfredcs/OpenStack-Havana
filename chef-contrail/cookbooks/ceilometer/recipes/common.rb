#
# Cookbook Name:: ceilometer
# Recipe:: ceilometer-common
#
# Copyright 2013, Cloudscaling Group, Inc.
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

package "ceilometer-common"

#include_recipe "nova::base"

dependent_pkgs = node["ceilometer"]["dependent_pkgs"]
dependent_pkgs.each do |pkg|
  package pkg do
    action :upgrade
  end
end

# create conf
directory "/etc/ceilometer" do
  owner node['ceilometer']['user']
  group node['ceilometer']['group']
  mode  00755

  action :create
end
