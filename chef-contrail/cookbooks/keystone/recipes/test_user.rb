
template "/etc/keystone/create_test_user.sh" do
  owner "root"
  group "root"
  mode 0755
  variables(service: node['openstack_config']['services']['keystone'])
end


execute "/etc/keystone/create_test_user.sh" do
  user "root"
  group "root"
  action :run
end


