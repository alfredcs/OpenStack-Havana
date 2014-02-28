#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#
default['swift']['app_ip'] = OCS.app_ip(node)
default['swift']['proxy_server']['bind_ip'] = node['swift']['app_ip']
default['swift']['proxy_server']['bind_port'] = "8000"
#default['swift']['proxy_server']['s3_address'] = "#{node['ipaddress']}"
#default['swift']['proxy_server']['cluster_address'] = "http://#{node['ipaddress']}:#{node['swift']['proxy_server']['bind_port']}"
default['swift']['proxy_server']['reseller_prefix'] = ''
default['swift']['proxy_server']['workers'] = (node['cpu']['total']*1.5).to_i
default['swift']['proxy_server']['replicator_workers'] = "10"
default['swift']['proxy_server']['auth_ip'] = '127.0.0.1'
default['swift']['proxy_server']['auth_port'] = "443"
default['swift']['proxy_server']['auth_use_ssl'] = false  ## This is true or false only
default['swift']['proxy_server']['auth_type'] = 'keystone'
default['swift']['proxy_server']['swauth']['version'] = '1.0.2'
default['swift']['proxy_server']['nginx_listen_ip'] = '*'
default['swift']['proxy_server']['auth_url'] = 'http://127.0.0.1:8080/auth'
default['swift']['proxy_server']['memcache_servers'] = '127.0.0.1:11211'
default['swift']['proxy_server']['packages'] = %w{memcached}

# grab memcache cluster IPs from substatum
default['swift']['proxy_server']['cluster_address'] = "http://#{OCS.app_ecmp_ip}"
default['swift']['proxy_server']['s3_address'] = OCS.app_ecmp_ip

default['swift']['proxy_server']['ratelimit_settings'] = {
  'clock_accuracy' => '1000',
  'max_sleep_time_seconds' => '60',
  'account_ratelimit' => '0',
  'account_whitelist' => 'a,b',
  'account_blacklist' => 'c,d',
  'container_limit_x' => 'r',
  'container_ratelimit_0' => '100',
  'container_ratelimit_10' => '50',
  'container_ratelimit_50' => '20'
}

# keystone variable... they need to match the one in the keystone recipe and be overiden by deployment data

default['swift']['proxy_server']['keystone']['service_host'] = "127.0.0.1"
default['swift']['proxy_server']['keystone']['service_port'] = "5000"
default['swift']['proxy_server']['keystone']['auth_host'] = node['quagga']['ospfd']['app_ecmp_ip']
default['swift']['proxy_server']['keystone']['auth_port'] = "35357"
default['swift']['proxy_server']['keystone']['auth_protocol'] = "http"
default['swift']['proxy_server']['keystone']['auth_token'] = "ADMIN"
default['swift']['proxy_server']['keystone']['admin_token'] = "ADMIN"
default['swift']['proxy_server']['keystone']['operator_roles'] = "ResellerAdmin, Member, admin, swiftoperator"
default['swift']['proxy_server']['keystone']['admin_tenant_name'] = "service"
default['swift']['proxy_server']['keystone']['admin_user'] = "swift"
