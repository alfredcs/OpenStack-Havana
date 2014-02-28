include_recipe "mysql::server"

grant "ceilometer" do
  user node['ceilometer']['mysql']['user']
  database node['ceilometer']['mysql']['database']
  password node['ceilometer']['mysql']['password']
end

execute "ceilometer-dbsync" do
  retries 5
end
