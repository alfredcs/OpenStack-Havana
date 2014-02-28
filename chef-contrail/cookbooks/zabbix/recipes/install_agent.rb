# Author:: Benjamin Staffin <ben@cloudscaling.com>
# Cookbook Name:: zabbix
# Recipe:: install_agent

package "zabbix-agent"

template "/etc/zabbix/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[zabbix-agent]"
end

directory node['zabbix_agent']['log_dir'] do
  owner "zabbix"
  group "zabbix"
  mode 00755
  action :create
  recursive true
end

file "#{node['zabbix_agent']['log_dir']}/zabbix_agentd.log" do
  owner "zabbix"
  group "zabbix"
  mode 00644
end

directory node['zabbix_agent']['run_dir'] do
  owner "zabbix"
  group "zabbix"
  mode 00755
  action :create
  recursive true
end

file "#{node['zabbix_agent']['run_dir']}/zabbix_agentd.pid" do
  owner "zabbix"
  group "zabbix"
  mode 00644
end

service "zabbix-agent" do
  supports :status => true,
    :start => true,
    :stop => true,
    :restart => true
  action :enable
end
