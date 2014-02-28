#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name             "swift"
maintainer       "Cloudscaling"
maintainer_email "rodolphe@cloudscaling.com"
license          "Apache 2.0"
description      "Installs/Configures swift"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"
depends          "default"

recipe "swift::default", "Check that health_service_url is define. Also include install.rb"
recipe "swift::install", "Install Swift and its dependencies"
recipe "swift::proxy_server", "Install swift proxy server configurations and dependencies"
recipe "swift::account_server", "Install and configure Swift account server"
recipe "swift::object_server", "Install and configure Swift object server and its dependencies, format disk, mount them"
recipe "swift::start", "Should not be used as it's creating the ring and is swauth specific."



######### default attribute ###################
attribute "swift/mount_options",
  :display_name => "filesystem mount options for the (XFS) storage elements (as placed in fstab)",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/super_admin_key",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/user",
  :display_name => "the (unix) user the swift processes will run as",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/group",
  :display_name => "the (unix) group the swift processes will run as",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/home",
  :display_name => "the home directory for the swift user",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/version",
  :display_name => "the version of swift to install",
  :description => "normally you won't set this as the default is chosen and vetted",
  :required => "optional",
  :type => "string"

attribute "swift/pathsuffix",
  :display_name => "the path-hash suffix used in internal ring calculations",
  :description => "this is a secret high-entropy (160+ bits) string used to salt the calculations into the ring",
  :required => "required",
  :type => "string"

attribute "swift/directories",
  :display_name => "a list of directories to be owned by the swift user & group",
  :description => "end-users normally would not set this",
  :required => "optional",
  :type => "array"

attribute "swift/templates",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "array"

# this shouldn't be documented for end-users
attribute "swift/tcp_kernel_opts/net.ipv4.tcp_tw_recycle",
  :display_name => "allow faster reuse of ephemeral ports",
  :description => "use the default",
  :required => "optional",
  :type => "string"

# this shouldn't be documented for end-users
attribute "swift/tcp_kernel_opts/net.ipv4.tcp_tw_reuse",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

# this shouldn't be documented for end-users
attribute "swift/tcp_kernel_opts/net.ipv4.tcp_syncookies",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/packages",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "array"

attribute "swift/health_service_url",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/health_service_req_trigger",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/health_service_app",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/metrics_service_url",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/metrics_service_app",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

######### proxy_server attribute ###################

attribute "swift/proxy_server/bind_ip",
  :display_name => "the IP address which the swift proxy will listen on for incoming connections",
  :description => "",
  :default => "0.0.0.0",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/bind_port",
  :display_name => "the PORT which the swift proxy will listen on for incoming connections",
  :description => "",
  :default => "8080",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/cluster_address",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/reseller_prefix",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/workers",
  :display_name => "the number of worker-processes to start on each proxy",
  :description => "this should be approxmately as many hardware threads as the machine physically has (or little higher)",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/replicator_workers",
  :display_name => "the number of works user for replication",
  :description => "typically 4-6 on an 8c16t machine",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/use_ssl",
  :display_name => "a yes/no flag to indicate whether or not the proxy will listen using SSL",
  :description => "for public facing proxies typically you want this enabled",
  :required => "required",
  :type => "symbol"

attribute "swift/proxy_server/auth_ip",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/auth_port",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/auth_use_ssl",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "symbol"

attribute "swift/proxy_server/auth_type",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string",
  :choice => [ "auth", "swauth", "keystone" ]

attribute "swift/proxy_server/swauth/version",
  :display_name => "the version of swauth to use",
  :description => "use the default as this is carefuly chosed and vetter",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/nginx_listen_ip",
  :display_name => "",
  :description => "deprecated, don't use",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/auth_url",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/memcache_servers",
  :display_name => "a command separate list of memcached servers for the proxies to use",
  :description => "ideally there should be more than one of these and the listed addresses be internally reachable for all proxies",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/packages",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "array"

attribute "swift/proxy_server/ratelimit_settings/clock_accuracy",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/max_sleep_time_seconds",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/account_ratelimit",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/account_whitelist",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/account_blacklist",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/container_limit_x",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/container_ratelimit_0",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/container_ratelimit_10",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "swift/proxy_server/ratelimit_settings/container_ratelimit_50",
  :display_name => "",
  :description => "",
  :required => "optional",
  :type => "string"


attribute "swift/proxy_server/keystone/service_host",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/keystone/service_port",
  :display_name => "",
  :description => "",
  :required => "required",
  :default => "5000",
  :type => "string"

attribute "swift/proxy_server/keystone/auth_host",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/keystone/auth_port",
  :display_name => "",
  :description => "",
  :required => "required",
  :default => "35357",
  :type => "string"

attribute "swift/proxy_server/keystone/auth_protocol",
  :display_name => "",
  :description => "",
  :required => "required",
  :default => "http",
  :type => "string"

attribute "swift/proxy_server/keystone/auth_token",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/keystone/admin_token",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/keystone/operator_roles",
  :display_name => "",
  :description => "ResellerAdmin, Member, admin",
  :required => "required",
  :default => "",
  :type => "string"

attribute "swift/proxy_server/keystone/admin_tenant_name",
  :display_name => "",
  :description => "",
  :default => "service",
  :required => "required",
  :type => "string"

attribute "swift/proxy_server/keystone/admin_user",
  :display_name => "",
  :description => "",
  :required => "required",
  :default => "swift",
  :type => "string"

attribute "swift/proxy_server/keystone/admin_password",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

######### account_server attribute ###################
attribute "swift/account_server/servers",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "array"

attribute "swift/account_server/secondary_servers",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "array"

######### object_server attribute ###################
attribute "swift/object_server/filesystems",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "string"

attribute "swift/object_server/servers",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "array"

attribute "swift/object_server/secondary_servers",
  :display_name => "",
  :description => "",
  :required => "required",
  :type => "array"
