#
# Cookbook Name:: glance
# Recipe:: common
#
# Copyright 2011 Opscode, Inc.
# Copyright 2011 Rackspace, Inc.
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

include_recipe "openstack_config::sqlalchemy"

services = %w{api registry}  # <-- Is this used for anything?

%w{ wget libjs-jquery libjs-sphinxdoc
    libjs-underscore python-glance-doc }.each do |pkg|
  package pkg
end


%w{ glance glance-api glance-registry }.each do |p|
  package p
end

node['glance']['packages'].each do |p|
  package p
end


template "/etc/glance/glance-api.conf" do
  source "glance-api.conf.erb"
  owner node['glance']['user']
  mode 0644
  notifies :restart, "service[glance-api]"
end

cookbook_file "/etc/glance/glance-api-paste.ini" do
   source "glance-api-paste.ini"
   owner node['glance']['user']
   mode 0644
   notifies :restart, "service[glance-api]"
end

template "/etc/glance/glance-registry.conf" do
  source "glance-registry.conf.erb"
  owner node['glance']['user']
  mode 0644
  notifies :restart, "service[glance-registry]"
end

execute "glance upgrade" do
  command "glance-manage version_control 0 && glance-manage db_sync"
  creates "/var/lib/glance/.upgraded"
  action :run
  notifies :restart, "service[glance-api]"
  notifies :restart, "service[glance-registry]"
  not_if "glance-manage db_version"
end

service "glance-registry" do
  supports :restart => true, :reload => true
  action :enable
  subscribes :restart, resources("template[/etc/glance/glance-registry.conf]"), :immediately
  subscribes :restart, resources("execute[glance upgrade]"), :immediately

end

service "glance-api" do
  supports :restart => true, :reload => true
  action :enable
  subscribes :restart, resources("template[/etc/glance/glance-api.conf]"), :immediately
  subscribes :restart, resources("execute[glance upgrade]"), :immediately
end

beaver_log "glance" do
  file "/var/log/glance/*"
  type "glance"
end
