#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

default['swift']['app_ip'] = OCS.app_ip(node)

default['swift']['object_server']['mount_point_root_dir'] = '/srv/node'

default['swift']['mount_options'] = 'noatime,logbufs=8'
default['swift']['super_admin_key'] = 'scalingclouds'
default['swift']['user'] = 'swift'
default['swift']['uid'] = '20000'
default['swift']['group'] = 'swift'
default['swift']['home'] = '/home/swift'
default['swift']['version'] = '1.4.8'
default['swift']['partpower'] = "18"
default['swift']['replicants'] = '3'
default['swift']['timeout'] = '1'
default['swift']['weight'] = '100'
default['swift']['pathsuffix'] = '255436066572432'
default['swift']['directories'] = %w{
  /var/run/swift
  /etc/swift
  /etc/swift/backups
  /var/log/swift/stats
  /var/log/swift/hourly
  /home/swift
  /var/cache/swift
}
default['swift']['templates'] = %w{
  /etc/swift/swift.conf
}
#  /etc/rsyncd.conf

default['swift']['tcp_kernel_opts'] = {
  'net.ipv4.tcp_tw_recycle' => '1',
  'net.ipv4.tcp_tw_reuse' => '1',
  'net.ipv4.tcp_syncookies' => '0'
}

default['swift']['monitoring']['health_service_url'] = 'tcp://10.1.0.1:4999'
default['swift']['monitoring']['health_service_req_trigger'] = '2000'
default['swift']['monitoring']['health_service_app'] = 'swift'

default['swift']['monitoring']['metrics_service_url'] = 'tcp://10.1.0.1:4998'
default['swift']['monitoring']['metrics_service_app'] = 'swift'

default['swift']['log_level'] = 'INFO'
