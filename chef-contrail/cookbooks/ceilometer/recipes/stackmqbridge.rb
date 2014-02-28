# Copyright 2013, Cloudscaling Group Inc.
# Proprietary and confidential

package "python-kombu"
package "python-oslo.config"
package "python-stackmqbridge"
package "stackmqbridge-notifications"

directory "/etc/stackmqbridge"

template "/etc/stackmqbridge/stackmqbridge.conf" do
  source "stackmqbridge.conf.erb"
  mode 0440
  owner node['ceilometer']['user']
  group node['ceilometer']['group']
end

service "stackmqbridge-notifications" do
  service_name "stackmqbridge-notifications"
  action [:enable, :start]
end
