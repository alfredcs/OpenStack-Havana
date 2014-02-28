include_recipe "apache2"

package "openstack-dashboard"

directory "/etc/openstack-dashboard"

template "/etc/openstack-dashboard/local_settings.py" do
  source "local_settings.py.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :memcached_servers => OCS.ips_for_service('memcached').map {|ip| "'#{ip}:#{node['memcached']['port']}'" }.join(',')
  })
end

file "/etc/apache2/conf.d/openstack-dashboard-p80.conf" do
  action :delete
end

template "/etc/apache2/conf.d/openstack-dashboard.conf" do
  source "openstack-dashboard.conf.erb"
  owner "root"
  group "root"
  mode 0444
end

# To load the above configuration file.
service "apache2" do
  action :reload
end
