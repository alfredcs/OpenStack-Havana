# To get the "grant" method only, don't install a server wherever this is used.
include_recipe "mysql"

grant "cinder" do
  user node['cinder']['mysql']['user']
  database node['cinder']['mysql']['database']
  password node['cinder']['mysql']['password']
end
