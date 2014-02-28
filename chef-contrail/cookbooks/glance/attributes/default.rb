#
# Cookbook Name:: glance
# Attributes:: default
#
# Copyright 2011, Opscode, Inc.
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

# keystone authtoken for *.ini
default['glance']['keystone']['admin_user'] = "glance"
default['glance']['keystone']['enabled'] = true

default['glance']['app_ip'] = OCS.app_ip(node)

override['glance']['user']="glance"
#NOTE(jogo): this is a hack, 4+ glance config files now
default['glance']['config_file'] = "/etc/glance/glance-api.conf"
default['glance']['working_directory'] = "/var/lib/glance"
default['glance']['pid_directory'] = "/var/run/glance/"

default['glance']['enable_v2_api'] = true
default['glance']['api_bind_host'] = node['glance']['app_ip']
default['glance']['api_bind_port'] = "9292"
default['glance']['api_workers'] = "0"
default['glance']['registry_host'] = node['glance']['app_ip']
default['glance']['registry_bind_host'] = node['glance']['app_ip']
default['glance']['registry_bind_port'] = "9191"
default['glance']['sql_idle_timeout'] = "3600"
default['glance']['mysql']['user'] = "glance"
default['glance']['mysql']['database'] = "glance"
default['glance']['mysql']['host'] = OCS.mysql_ip

glance_nodes = OCS.ips_for_service('glance').select {|ip| ip != node['glance']['app_ip']}
default['glance']['peers'] = glance_nodes.map do |peer|
  "#{peer}:#{node['glance']['api_bind_port']}"
end
default['glance']['local'] = "#{node['glance']['app_ip']}:#{node['glance']['api_bind_port']}"

#default_store choices are: file, http, https, swift, s3
default['glance']['default_store'] = "swift"
default['glance']['filesystem_store_datadir'] = "/var/lib/glance/images"

default['glance']['swift_store_auth_address'] = "127.0.0.1:8000/v1.0/"
default['glance']['swift_store_user'] = "service:swift"
default['glance']['swift_store_key'] = "swift_store_key"
default['glance']['swift_store_container'] = "glance"
default['glance']['swift_store_create_container_on_put'] = "True"
default['glance']['swift_store_multi_tenant'] = "True"

default['glance']['images'] = {
  "http://mirror.cloudscaling.com/images/cirros-0.3.0-x86_64-disk.img" => {
     "image" => "cirros-0.3.0-x86_64-disk.img",
     "kernel_version" => "3.0.32",
     "arch" => "amd64",
     "distro" => "CirrOS",
     "version" => "0.3.0"
   }
}

default['glance']['packages'] = %w{ python-eventlet python-routes
  python-greenlet python-sqlalchemy python-wsgiref python-pastedeploy
  python-lxml python-migrate python-passlib mysql-client curl unzip
  python-setuptools python-keystoneclient }
