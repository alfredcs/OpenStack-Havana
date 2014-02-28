#
# Cookbook Name:: swift
# Recipe:: install
#
# Copyright 2010, Cloudscaling
#
# This recipe installs the most basic stuff to run swift. All of the
# configuration bits should be condensed in attributes/default['rb'] so
# take a look there first if you want to see what things are getting
# set to


### TODO: need to handle ntp, and logging homogenously
### TODO: include_recipe "swift::log-collector"
### TODO: include_recipe "swift::proxy-server-conf"


## make python packages avilable for install
package "swift"
package "python-swiftclient"

## create the swift user
user node['swift']['user'] do
  manage_home true
  home node['swift']['home']
  uid node['swift']['uid'] 
end

if node['ceilometer']['agent_enabled']
  group 'ceilometer' do
    action :manage
    append true
    members node['swift']['user']
  end
end

## swift needs a few directories created to function properly
node['swift']['directories'].each do |dir|
  directory dir do
    owner node['swift']['user']
    group node['swift']['group']
    mode 0700
    recursive true
  end
end

template "/etc/sysctl.d/20-swift-tcp.conf" do
  source "20-swift-tcp.conf.erb"
  mode 0600
  owner "root"
  group "root"
end

service "procps" do
  supports :start => true, :restart => true, :stop => true
  action [:enable, :restart]
end

## Ensure pathsuffix.conf is gone
file "/etc/swift/pathsuffix.conf" do
  action :delete
end


## generate the templates defined in the node['swift']['templates'] attribute
node['swift']['templates'].each do |t|
  template t
end


## create a basic rsync config file
file "/etc/default/rsync" do
  content "
RSYNC_ENABLE=true
RSYNC_OPTS=''
RSYNC_NICE=''
"
end

# setup logging under /var/log/swift for all swift processes
cookbook_file "/etc/rsyslog.d/10-swift.conf" do
  source '10-swift.conf'
end


##  create a basic swift configuration file with node['swift']['pathsuffix']
file "/etc/swift/swift.conf" do
  owner node['swift']['user']
  group node['swift']['group']
  content "
[swift-hash]
swift_hash_path_suffix = #{node['swift']['pathsuffix']}
"
end
directory "/etc/rsyncd.d" do
  owner "root"
  group "root"
  mode 0600
end

## generate rsyncd conf. Not sure if any servers are ever provided :\
## TODO: see if there is something better here
template "/etc/rsyncd.d/rsyncd.swift.conf" do
  source "rsyncd.swift.conf.erb"
  variables({
    :servers => %w[ container object account ] 
  })
end

directory "/etc/rsyncd.d" do
  owner "root"
  group "root"
  mode 0600
end

execute "merge_rsyncd.conf" do
  command "cat /etc/rsyncd.d/* > /etc/rsyncd.conf"
end

service "rsync" do
        supports :status => true, :restart => true, :restart => true
 action [ :enable, :start ]
end
