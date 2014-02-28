include_recipe 'contrail::base'

package 'contrail-openstack-control'

cookbook_file "/etc/init/contrail-control.conf" do
  source "contrail-control.conf"
  mode 0644
end

service "contrail-control" do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

template "#{node['contrail']['config_dir']}/control_param" do
  source "control_param.erb"
  notifies :restart, "service[contrail-control]"
end

template "#{node['contrail']['config_dir']}/dns_param" do
  source "dns_param.erb"
  notifies :restart, "service[contrail-control]"
end

file "#{node['contrail']['log_dir']}/controller.log" do
  action :create_if_missing
end

execute "supervisor-control restart" do
  command "service supervisor-control restart"
end
