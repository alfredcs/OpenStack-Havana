include_recipe "quagga::default"

template "/etc/quagga/ospfd.conf" do
  mode 0644
  owner "quagga"
  group "quaggavty"
  notifies :restart, "service[quagga]", :delayed
end

template "/etc/quagga/zebra.conf" do
  mode 0644
  owner "quagga"
  group "quaggavty"
  notifies :restart, "service[quagga]", :delayed
end

app_ecmp_ip = node['quagga']['ospfd']['app_ecmp_ip']
execute "add the internal ip address to the node's loopback dev" do
  command "ip addr add #{app_ecmp_ip} dev lo label lo:2"
  only_if "test -z '$(ip addr | grep #{app_ecmp_ip})'"
end

service "quagga" do
  supports :restart => true
  action [ :enable, :start ]
end
