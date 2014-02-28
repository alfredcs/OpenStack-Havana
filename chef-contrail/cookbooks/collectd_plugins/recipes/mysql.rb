include_recipe "collectd"

collectd_plugin "mysql"


template "/etc/collectd/plugins/mysql.conf" do
  cookbook "collectd" # the rest of the templates are in this cookbook
  source "mysql_plugin.conf.erb"
  # collectd supports multiple database monitoring, use the array of hashes to
  # configure
  variables(
    :databases => [
      { "Database" => node['nova']['mysql']['database'],
        "Host" => node['nova']['mysql']['host'],
        "User" => node['nova']['mysql']['user'],
        "Password" => node['nova']['mysql']['password'],
        # Once we get replication going we will want to enable this:
        #"MasterStats" => "true"
      }
    ])
end


