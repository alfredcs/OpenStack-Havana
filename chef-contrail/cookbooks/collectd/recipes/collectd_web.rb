#
# Cookbook Name:: collectd
# Recipe:: collectd_web
#
# Copyright 2010, Atari, Inc
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

include_recipe "collectd"
include_recipe "apache2"

package "collectd-web"

directory node['collectd']['collectd_web']['path'] do
  owner "root"
  group "root"
  mode "755"
end

file File.join(node['collectd']['collectd_web']['path'], "cgi-bin", "graphdefs.cgi") do
  mode "755"
  owner node['apache']['user']
end

template "/etc/apache2/sites-available/collectd_web.conf" do
  source "collectd_web.conf.erb"
  owner "root"
  group "root"
  mode "644"
end

apache_site "000-default" do
  enable false
end

template "#{node['collectd']['collectd_web']['path']}/.htaccess" do
  source "htaccess.erb"
  owner "root"
  group "root"
  mode "0644"
  only_if { node['collectd']['collectd_web'].attribute?("htaccess_user") }
end

bash "Setting .htaccess password" do
  user "root"
  cwd node['collectd']['collectd_web']['path']
  code <<-EOH
  htpasswd -bc "#{node['collectd']['collectd_web']['path']}/.htpasswd #{node['collectd']['collectd_web']['htaccess_user']} #{node['collectd']['collectd_web']['htaccess_password']}"
  EOH
end if node['collectd']['collectd_web'].attribute?("htaccess_user") and node['collectd']['collectd_web'].attribute?("htaccess_password")

bash "Enable htaccess for collectd_web in apache configuration" do
  user "root"
  code <<-EOH
  sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/sites-available/collectd_web.conf
  EOH
  only_if { node['collectd']['collectd_web'].attribute?("htaccess_user") }
end

apache_site "collectd_web.conf"
