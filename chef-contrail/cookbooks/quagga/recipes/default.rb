#
# Cookbook Name:: quagga
# Recipe:: default
#

apt_package "quagga"

directory "/etc/quagga" do
  mode 0775
  owner "quagga"
  group "quaggavty"
end

cookbook_file "/etc/quagga/daemons" do
  mode 0644
  owner "quagga"
  group "quaggavty"
  notifies :restart, "service[quagga]", :delayed
end

cookbook_file "/etc/quagga/debian.conf" do
  mode 0644
  owner "quagga"
  group "quaggavty"
  notifies :restart, "service[quagga]", :delayed
end

file "/etc/profile.d/quaggavty.sh" do
  content "export VTYSH_PAGER=cat"
end
