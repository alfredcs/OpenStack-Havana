#
# Cookbook Name:: heat
# Recipe:: api-cloudwatch
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

package "heat-api-cloudwatch"

directory "/etc/heat/templates" do
  owner node['heat']['user']
  group node['heat']['group']
  mode "0755"
  action :create
end

cookbook_file "/etc/heat/templates/AWS_CloudWatch_Alarm.yaml" do
  source "AWS_CloudWatch_Alarm.yaml"
  owner node['heat']['user']
  group node['heat']['group']
  mode  0640
end

cookbook_file "/etc/heat/templates/AWS_RDS_DBInstance.yaml" do
  source "AWS_RDS_DBInstance.yaml"
  owner node['heat']['user']
  group node['heat']['group']
  mode  0640
end

service "heat-api-cloudwatch" do
  provider Chef::Provider::Service::Upstart
  action [:restart, :enable]
end
