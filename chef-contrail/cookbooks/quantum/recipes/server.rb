#
# Cookbook Name:: Quantum 
# Recipe:: server
#
# Copyright 2013, Cloudscaling, Inc.
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
#
package "quantum-server"

case node['quantum']['plugin']
when 'contrail'
  include_recipe "contrail::quantum"

  directory "/etc/quantum/plugins/contrail" do
    recursive true
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  template "/etc/quantum/plugins/contrail/contrail_plugin.ini" do
    source "contrail_plugin.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    action :create
  end

when 'linuxbridge'
  package "quantum-plugin-linuxbridge"

  directory "/etc/quantum/plugins/linuxbridge" do
    recursive true
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  template "/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini" do
    source "linuxbridge_conf.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    action :create
  end

else
  raise "If quantum is enabled you must specify a plugin to install!"
end

service "quantum-server" do
     action [:enable, :start]
end

template "/etc/quantum/quantum.conf" do
  source "quantum.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/quantum/api-paste.ini" do
  source "api-paste.ini.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "quantum-server" do
     action :restart
end
