default['rabbitmq']['nodename'] = "rabbit@#{node['fqdn'].split('.').first}"
default['rabbitmq']['ip'] = OCS.app_ip(node)
default['rabbitmq']['port'] = 5672
default['rabbitmq']['config'] = "/etc/rabbitmq/rabbitmq"
default['rabbitmq']['logdir'] = nil
default['rabbitmq']['mnesiadir'] = nil

default['rabbitmq']['erlang_cookie'] = "119972eb75016f7172181680ba17838e"
