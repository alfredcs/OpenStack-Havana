default['keystone']['app_ip'] = OCS.app_ip(node)

default['openstack_config']['keystone_listen'] = node['keystone']['app_ip']

default['keystone']['user'] = "keystone"
default['keystone']['group'] = "keystone"

default['keystone']['code_dir'] = "/var/tmp/keystone"

default['keystone']['log_file'] = "/var/log/keystone/keystone.log"
default['keystone']['use_syslog'] = false
default['keystone']['syslog_log_facility'] = "LOG_LOCAL0"

default['keystone']['sql']['idle_timeout'] = "200"
default['keystone']['sql']['min_pool_size'] = "5"
default['keystone']['sql']['max_pool_size'] = "10"
default['keystone']['sql']['pool_timeout'] = "2000"

default['keystone']['mysql']['user'] = "keystone"
default['keystone']['mysql']['database'] = "keystone"
default['keystone']['mysql']['host'] = OCS.mysql_ip



default['keystone']['catalog']['db_backed'] = true

# these need to be defined in the deployment metadata

default['keystone']['token']['expiration'] = "86400"

default['keystone']['public_port'] = "5000"
default['keystone']['admin_port'] = "35357"

default['keystone']['admin_token'] = "ADMIN"

# default['keystone']['keystone_ip'] = "192.168.11.11"

# default['keystone']['compute_ip'] = "192.168.11.11"
default['keystone']['compute_port'] = "8774"

# default['keystone']['volume_ip'] = "192.168.11.11"
default['keystone']['volume_port'] = "8776"

# default['keystone']['ec2_ip'] = "192.168.11.11"
default['keystone']['ec2_port'] = "8773"

# default['keystone']['swift_ip'] = "192.168.11.11"
default['keystone']['swift_port'] = "8080"
