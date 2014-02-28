default['contrail']['app_ip'] = OCS.app_ip(node)
default['contrail']['app_cidr'] = OCS.app_ip_cidr(node)

default['contrail']['config_dir'] = "/etc/contrail"
default['contrail']['log_dir'] = "/var/log/contrail"

default['contrail']['router_asn'] = 65002

# Redis
default['contrail']['redis']['uve_ip'] = "127.0.0.1"
default['contrail']['redis']['query_ip'] = "127.0.0.1"
default['contrail']['redis']['web_ip'] = "127.0.0.1"
default['contrail']['redis']['uve_port'] = 6381
default['contrail']['redis']['query_port'] = 6380
default['contrail']['redis']['web_port'] = 6383

default['contrail']['redis']['ip'] = OCS.zm_app_ips.first

# Zookeeper

default['contrail']['zookeeper']['nodes'] = OCS.ips_for_service('zookeeper')

# Addresses of singular services
#TODO(jpg) This should be HA, should ask Juniper to ensure irond is not SPOF
config_nodes = OCS.ips_for_service('contrail_config')
config_node_ip = config_nodes.empty? ? nil : config_nodes.first
default['contrail']['api_server']['ip'] = OCS.app_ip(node)
default['contrail']['collector']['ip'] = OCS.app_ip(node)
default['contrail']['opserver']['ip'] = config_node_ip
default['contrail']['ifmap']['ip'] = OCS.app_ip(node)
default['contrail']['discovery']['ip'] = OCS.app_ip(node)

# Discovery
default['contrail']['discovery']['port'] = 5998
default['contrail']['discovery']['backend_port'] = 9110
default['contrail']['discovery']['config_file'] = "#{node['contrail']['config_dir']}/discovery.conf"

# Agent
default['contrail']['agent']['vhost'] = "vhost0"
default['contrail']['agent']['eth_port'] = OCS.app_iface(node)
default['contrail']['agent']['gateway_ip'] = node['gateway_ip']
default['contrail']['agent']['config_file'] = "#{node['contrail']['config_dir']}/agent.conf"
default['contrail']['agent']['log_file'] = "#{node['contrail']['log_dir']}/agent.log"

# API server
default['contrail']['api_server']['port'] = 8082
default['contrail']['api_server']['backend_port'] = 9100
default['contrail']['keyfile'] = "#{node['contrail']['config_dir']}/ssl/private_keys/apiserver_key.pem"
default['contrail']['certfile'] = "#{node['contrail']['config_dir']}/ssl/certs/apiserver.pem"
default['contrail']['ca_cert'] = "#{node['contrail']['config_dir']}/ssl/certs/ca.pem"
default['contrail']['api_server']['config_file'] = "#{node['contrail']['config_dir']}/api_server.conf"
default['contrail']['api_server']['log_file'] = "#{node['contrail']['log_dir']}/api_server.log"

# Schema Transformer
default['contrail']['schema_transformer']['config_file'] = "#{node['contrail']['config_dir']}/schema_transformer.conf"

# Controller
default['contrail']['controller_ips'] = OCS.ips_for_service('contrail_controller')
default['contrail']['controller']['bgp_port'] = 179
default['contrail']['controller']['log_file'] = "#{node['contrail']['log_dir']}/controller.log"

# Collector
default['contrail']['collector']['port'] = 9009
default['contrail']['collector']['http'] = 8089
default['contrail']['collector']['log_file'] = "#{node['contrail']['log_dir']}/collector.log"

# DNS
default['contrail']['named']['config_file'] = "#{node['contrail']['config_dir']}/dns/named.conf"
default['contrail']['dnsd']['log_file'] = "#{node['contrail']['log_dir']}/dns.log"

# IFMAP/irond
default['contrail']['ifmap']['basic_port'] = 8443
default['contrail']['ifmap']['cert_port'] = 8444
default['contrail']['ifmap']['port'] = node['contrail']['ifmap']['basic_port']
default['contrail']['irond']['ifmap'] = "/etc/irond/ifmap.properties"
default['contrail']['irond']['keystore'] = "/usr/share/irond/keystore/irond.jks"
default['contrail']['irond']['authorization'] = "/etc/irond/basicauthusers.properties"

# Opserver
default['contrail']['opserver']['http_port'] = 8090
default['contrail']['opserver']['rest_port'] = 8081
default['contrail']['opserver']['log_file'] = "#{node['contrail']['log_dir']}/opserver.log"

# Web UI
default['contrail']['webui']['listen_addresses'] = [ OCS.app_ip(node) ]
default['contrail']['webui']['http_port'] = 8079
default['contrail']['webui']['https_port'] = 8143
default['contrail']['webui']['job_port'] = 3000
default['contrail']['webui']['kue_port'] = 3002
