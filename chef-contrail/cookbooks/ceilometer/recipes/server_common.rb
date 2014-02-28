# Copyright 2013, Cloudscaling Group, Inc.
# Proprietary and confidential.

require 'uri'

include_recipe "ceilometer::common"

package "python-memcache"

db_scheme = node["ceilometer"]["db"]["scheme"]

if db_scheme == "mysql"
  db_uri = OCS.sql_string(node, 'ceilometer')
elsif db_scheme == 'mongodb'
  #include_recipe "mongodb"

  package 'python-pymongo' do
    action :upgrade
  end
else
  Chef::Log.warning "Only MySQL and MonogDB supported for Ceilometer."
end

db_settings = node['ceilometer']['db'][db_scheme]
db_uri ||= URI::Generic.build({
  :host => db_settings['host'],
  :port => db_settings['port'],
  :scheme => db_scheme,
  :userinfo => "#{db_settings['username']}:#{db_settings['password']}",
  :path => "/#{db_settings['database']}"
})

template "/etc/ceilometer/ceilometer.conf" do
  source "ceilometer.conf.erb"
  owner  node['ceilometer']['user']
  group  node['ceilometer']['group']
  mode   00440
  variables(
    :database_connection => db_uri.to_s,
    :user => 'ceilometer',
    :tenant => 'service',
    :password => node['openstack_config']['services']['ceilometer']['keystone_service_password'],
    :ks_admin_endpoint => OCS.keystone_internal_endpoint(node).to_s,
    :periodic_interval => node['ceilometer']['periodic_interval']
  )
end

cookbook_file "/etc/ceilometer/policy.json" do
  source "policy.json"
  mode 0755
  owner node['ceilometer']['user']
  group node['ceilometer']['group']
end

if db_scheme == "mysql"
  # Install database and grants
  # this has to happen after creating the configuration file above
  include_recipe "ceilometer::mysql"
end
