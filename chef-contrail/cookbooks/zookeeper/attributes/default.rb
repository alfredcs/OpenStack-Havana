default['zookeeper']['conf_dir'] = "/etc/zookeeper/conf"
default['zookeeper']['data_dir'] = "/var/lib/zookeeper"

default['zookeeper']['client_port'] = 2181
default['zookeeper']['follow_port'] = 2888
default['zookeeper']['leader_port'] = 3888

default['zookeeper']['tick_time'] = 2000
default['zookeeper']['init_limit'] = 10
default['zookeeper']['sync_limit'] = 5
default['zookeeper']['prealloc_size'] = 65536
default['zookeeper']['leader_serves'] = "yes"
