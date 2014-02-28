# Copyright 2013 Cloudscaling Group, Inc.
# Proprietary and confidential

include_recipe "ceilometer::common"

template "/etc/ceilometer/ceilometer.conf" do
  source "ceilometer-agent.conf.erb"
  owner  node['ceilometer']['user']
  group  node['ceilometer']['group']
  mode   00644
  variables(
    :user => 'ceilometer',
    :tenant => 'service',
    :password => node['openstack_config']['services']['ceilometer']['keystone_service_password'],
    :ks_admin_endpoint => OCS.keystone_internal_endpoint(node).to_s,
    :periodic_interval => node['ceilometer']['periodic_interval']
  )
end
