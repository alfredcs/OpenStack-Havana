#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

file '/etc/hostname' do
  content node['fqdn'].split('.').first
  mode 0644
end

template '/etc/hosts' do
  source 'etc-hosts.erb'
  mode 0644
end

nameservers = OCS.zm_mgmt_ips.sort_by do |e|
  [ [OCS.mgmt_ip(node)].index(e) || 1, e ]
end

cookbook_file '/etc/sudoers' do
  source 'sudoers'
  mode 0440
end

template '/etc/resolv.conf' do
  source 'resolv.conf.erb'
  mode 0644
  variables(
    :zone => OCS.zone(1)['name'],
    :block => node['block_number'],
    :nameservers => nameservers
  )
end

execute 'update-hostname' do
  command "hostname #{node['fqdn'].split('.').first}"
end

execute 'update-motd' do
  user 'root'
  command 'run-parts --lsbsysinit /etc/update-motd.d > /run/motd'
  action :nothing
end

template '/etc/update-motd.d/30-ocs-machine-info' do
  mode 0755
  source 'ocs-machine-info-motd.erb'
  notifies :run, 'execute[update-motd]'
end

link '/etc/motd' do
  to '/var/run/motd'
end

# Entropy daemon for faster VM launching, SSL, etc.
package 'haveged'

package 'irqbalance' do
  action :install
end


execute 'update-sysctl' do
  user 'root'
  command 'sysctl -p /etc/sysctl.d/30-network-optimization.conf'
  action :nothing
end

cookbook_file "/etc/sysctl.d/30-network-optimization.conf" do
  source "network-optimization.conf"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, 'execute[update-sysctl]'
end

ohai "reload" do
  action :reload
end
