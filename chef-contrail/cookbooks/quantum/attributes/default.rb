default['quantum']['db']['name'] = "quantum"
default['quantum']['db']['username'] = "quantum"
default['quantum']['db']['database'] = "quantum"

default['quantum']['app_ip'] = OCS.app_ip(node)
default['quantum']['port'] = 9696

default['quantum']['log_file'] = "/var/log/quantum/server.log"

default['quantum']['tz_uuid'] = "somerandomshit" # TODO(abhishek) find out what this is
default['quantum']['mysql']['bind_address'] = OCS.mysql_ip

# Network Plugins
if OCS.service_enabled?('contrail_controller')
  default['quantum']['plugin'] = 'contrail'
else
  default['quantum']['plugin'] = 'linuxbridge'
end

providers = {
  'linuxbridge' => 'linuxbridge.lb_quantum_plugin.LinuxBridgePluginV2',
  'contrail' => 'contrail.ContrailPlugin.ContrailPlugin'
}

default['quantum']['provider'] = "quantum.plugins.#{providers[default['quantum']['plugin']]}"
