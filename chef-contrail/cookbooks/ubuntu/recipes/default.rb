#
# Cookbook Name:: ubuntu
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
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

include_recipe "apt"

execute "apt-key add /tmp/chef-solo/cookbooks/ubuntu/files/default/apt.key" do
  not_if "apt-key list | grep --quiet apt@cloudscaling.com"
end.run_action(:run)

execute "apt-key add /tmp/chef-solo/cookbooks/ubuntu/files/default/release.key" do
  not_if "apt-key list | grep --quiet release@cloudscaling.com"
end.run_action(:run)

execute "apt-key add /tmp/chef-solo/cookbooks/ubuntu/files/default/ubuntu-cloud-keyring.gpg" do
  not_if "apt-key list | grep --quiet 'Canonical Cloud Archive'"
end.run_action(:run)

# We don't need i386, and this prevents APT from blowing up if a repo doesn't include i386 packages
file "/etc/dpkg/dpkg.cfg.d/multiarch" do
  action :delete
end

file "/etc/apt/apt.conf.d/00no-install-recommends" do
  content "APT::Install-Recommends false;"
end

# contrail repo key
package "contrail-keyring" do
  action :install
  options "--allow-unauthenticated"
end

template "/etc/apt/sources.list" do
  mode 0644
  variables :code_name => node['lsb']['codename']
  notifies :run, 'execute[apt-get update]', :immediately
  source "sources.list.erb"
end

# Ensure avahi-daemon doesn't get installed anywhere in OCS
package "avahi-daemon" do
  action :purge
end

# Install user defined sysctl settings
cookbook_file "/etc/sysctl.d/60-cloudscaling-ipv6.conf" do
  source "60-cloudscaling-ipv6.conf"
  mode 0400
  owner "root"
  group "root"
end

service "procps" do
  supports :start => true, :restart => true, :stop => true
  action [:enable, :restart]
end

