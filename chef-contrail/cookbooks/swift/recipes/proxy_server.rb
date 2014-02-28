#
# Cookbook Name:: swift
# Recipe:: proxy_server
#
# Copyright 2010-2012, Cloudscaling
#
# This recipe will configure a node to be a swift proxy server
#

include_recipe 'swift'
package "swift-proxy"
package "swauth"

# Install swift3 middleware
include_recipe "swift::swift3"

# Patch keystone XXX TODO(jpg) RIP THIS SHIT OUT
ruby_block "patch-keystone-bug" do
  block do
    require 'open3'
    cmd = 'patch -p0'
    patch = <<-EOF
--- exception.py  2014-02-10 21:43:03.806179125 +0000
+++ /usr/share/pyshared/keystone/exception.py 2014-02-10 21:39:34.387973484 +0000
@@ -16,6 +16,7 @@

 from keystone.common import config
 from keystone.openstack.common import log as logging
+from keystone.openstack.common.gettextutils import _

 CONF = config.CONF
 LOG = logging.getLogger(__name__)
EOF

    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      stdin.puts patch
      stdin.close
      wait_thr.value
    end
  end
end

cron "swauth-cleanup-tokens" do
  user node['swift']['user']
  command "/usr/local/bin/swauth-cleanup-tokens -A #{node['swift']['proxy_server']['auth_url']} -K #{node['swift']['super_admin_key']} > /dev/null"
  minute "10"
  only_if { node['swift']['proxy_server']['auth_type'] == "swauth" }
end

## create swift proxy server config
template "/etc/swift/proxy-server.conf" do
  owner node['swift']['user']
  group node['swift']['group']
  variables({
    :memcached_servers => OCS.ips_for_service('memcached').map {|ip| "#{ip}:#{node['memcached']['port']}"}.join(',')
  })
end

# Install some testing tools
directory "#{node['swift']['home']}/tools" do
  owner 'root'
  group 'root'
  mode 0744
  action :create
end

templated_tools = %w{benchmark.sh dispersion.conf 
s3boto.py s3cfg s3cmd_install.sh swauth_add_test_user.sh}

templated_tools.each do |tool|
  template "#{node['swift']['home']}/tools/#{tool}" do
    source "#{tool}.erb"
    owner 'root'
    group 'root'
    mode 0744
  end
end

cookbook_file "#{node['swift']['home']}/tools/gen_ssl_cert.sh" do
  source 'gen_ssl_cert.sh'
  owner 'root'
  group 'root'
  mode 0744
end

# Install makering Ruby program
cookbook_file "#{node['swift']['home']}/tools/makering" do
  source 'makering'
  owner 'root'
  group 'root'
  mode 0744
end
