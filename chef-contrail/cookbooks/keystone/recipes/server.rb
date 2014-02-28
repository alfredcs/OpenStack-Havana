include_recipe "openstack_config::sqlalchemy"

# Install keystone
%w{python-eventlet python-routes python-greenlet python-sqlalchemy python-wsgiref python-pastedeploy python-lxml python-migrate python-passlib mysql-client curl unzip python-setuptools python-keystoneclient keystone keystone-doc python-keystone python-keystoneclient}.each do |p|
  package p
end

service "keystone" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  subscribes :restart, "template[/etc/keystone/keystone.conf]", :immediately
  subscribes :restart, "file[/etc/keystone/keystone.conf]", :immediately
  subscribes :restart, "template[/etc/keystone/policy.json]", :immediately
  subscribes :restart, "file[/etc/keystone/policy.json]", :immediately
  action :nothing
end

template "/etc/keystone/keystone.conf" do
  owner node['keystone']['user']
  group node['keystone']['group']
end

cookbook_file "policy.json" do
  path "/etc/keystone/policy.json"
  owner node['keystone']['user']
  group node['keystone']['group']
  action :create
end

execute "/usr/bin/keystone-manage db_sync" do
  user node['keystone']['user']
  group node['keystone']['group']
  action :run
end

template "/etc/keystone/create_keystone_data.sh" do
  owner node['keystone']['user']
  group node['keystone']['group']
  mode 0755
end

template "/etc/keystone/create_keystone_endpoints.sh" do
  owner node['keystone']['user']
  group node['keystone']['group']
  mode 0755
end

execute "/etc/keystone/create_keystone_data.sh" do
  user node['keystone']['user']
  group node['keystone']['group']
  action :run
end

execute "/etc/keystone/create_keystone_endpoints.sh" do
  user node['keystone']['user']
  group node['keystone']['group']
  action :run
end

beaver_log "keystone" do
  file "/var/log/keystone/*"
  type "keystone"
end
