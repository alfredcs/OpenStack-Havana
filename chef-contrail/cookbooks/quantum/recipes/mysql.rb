# To get the "grant" method only, don't install a server wherever this is used.
include_recipe "mysql"

# This magic creates db automatically
grant "quantum" do
  user node['quantum']['db']['username']
  database node['quantum']['db']['database']
  password node['quantum']['db']['password']
end

