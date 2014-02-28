#
# Cookbook Name:: quagga
# Recipe:: default
#

include_recipe "quagga::default"

template "/etc/quagga/ospfd.conf" do
  source "ospfd_natter_core.conf.erb"
  mode 0644
  owner "quagga"
  group "quaggavty"
  notifies :restart, "service[quagga]", :delayed
end

# config file for the 2nd ospfd process
template "/etc/quagga/ospfd_natter_edge.conf" do
  mode 0644
  owner "quagga"
  group "quaggavty"
  notifies :restart, "service[quagga]", :delayed
end

template "/etc/quagga/zebra.conf" do
  mode 0644
  owner "quagga"
  group "quaggavty"
  source "zebra_natter.conf.erb"
  notifies :restart, "service[quagga]", :delayed
end

service "quagga" do
  supports :restart => true
  action [ :enable, :start ]
end
