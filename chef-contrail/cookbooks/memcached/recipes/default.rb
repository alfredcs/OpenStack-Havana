package 'memcached'

service "memcached" do
  action [:enable]
end

template "/etc/memcached.conf" do
  source "memcached.conf.erb"
  owner "root"
  group "root"
  mode "0440"
  notifies :restart, "service[memcached]", :immediately
end
