default['redis']['conf_dir'] = "/etc/redis"
default['redis']['log_dir'] = "/var/log/redis"
default['redis']['data_dir'] = "/var/lib/redis"

default['redis']['home_dir'] = "/usr/local/share/redis"
default['redis']['pid_file'] = "/var/run/redis.pid"

default['redis']['db_basename'] = "dump.rdb"

default['redis']['user'] = 'redis'
default['redis']['uid '] = 335
default['redis']['gid'] = 335

default['redis']['log_level'] = "notice"
default['redis']['databases'] = 16
default['redis']['max_conn'] = 128

default['redis']['app_ip'] = OCS.app_ip(node)
default['redis']['port'] = 6383

default['redis']['timeout'] = "300"
default['redis']['glueoutputbuf'] = "yes"

default['redis']['saves'] = [["900", "1"], ["300", "10"], ["60", "10000"]]


# Contrail Redis instances
default['redis']['web_port'] = 6383
default['redis']['uve_port'] = 6381
default['redis']['query_port'] = 6380
