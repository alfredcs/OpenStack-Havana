# Cookbook Name:: natter
# Recipe:: default
# Copyright 2012, Cloudscaling, Inc.
# All rights reserved - Do Not Redistribute

include_recipe "mysql::client"

packages = %w[ python-setuptools python-support python-netaddr python-lockfile
   python-daemon bridge-utils nova-common python-mysqldb ]
packages.each {|pkg| package pkg }

package "cs-natter"

execute 'update-sysctl' do
  user 'root'
  command 'sysctl -p /etc/sysctl.d/30-natter-ipforward.conf'
  action :nothing
end

template "/etc/natter/natter.conf" do
  source "natter.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/nova/nova.conf" do
  source "nova.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/sysctl.d/30-natter-ipforward.conf" do
  source "natter-sysctl.conf"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, 'execute[update-sysctl]'
end

execute "rp_filter_sysctl" do
    command "for i in /proc/sys/net/ipv4/conf/*/rp_filter; do echo '0'> $i; done"
end

service "natter" do
  provider Chef::Provider::Service::Upstart
  action :start
end

package "cs-quagga-natter"

template "/usr/local/bin/check-iface" do
  source "check-iface.erb"
  mode "0755"
end

%w[ 2 3 ].each do |iface|
  link "/usr/local/bin/check-eth#{iface}" do
    to "/usr/local/bin/check-iface"
  end
end

monit_service 'cs-quagga-natter' do
  template_source 'quagga-natter.monit.erb'
  action :monitor
end

service "cs-quagga-natter" do
  supports :restart => true
  action [ :enable ]
end
