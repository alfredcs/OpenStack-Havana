include_recipe "nova::base"

package "awscli"

directory "/home/nova" do
  mode "0700"
  owner "nova"
  group "nova"
  recursive true
  action :create
end

remote_directory "/home/nova/tools" do
  action :create
end

template "/home/nova/tools/keystonecreds" do
  owner "root"
  group "root"
  mode "0700"
end
