# Cookbook Name:: zabbix
# Attributes:: default

# These directories get owned by the zabbix user.
default['zabbix_agent']['run_dir'] = '/var/run/zabbix'
default['zabbix_agent']['log_dir'] = '/var/log/zabbix-agent'

# 0 disables log rotation (let logrotate do it)
default['zabbix_agent']['max_logfile_size_mb'] = 0

default['zabbix_agent']['debug_level'] = 3
default['zabbix_agent']['source_ip'] = nil
default['zabbix_agent']['enable_remote_commands'] = 0
default['zabbix_agent']['log_remote_commands'] = 0

# You probably want to set this somewhere.
default['zabbix_agent']['servers'] = []

# ServerActive isn't implemented until 1.8.13. Ubuntu 12.04 has 1.8.11.
default['zabbix_agent']['servers_active'] = []

default['zabbix_agent']['hostname'] = node['fqdn']
default['zabbix_agent']['hostname_item'] = nil
default['zabbix_agent']['listen_port'] = 10050
default['zabbix_agent']['listen_ip'] = nil
default['zabbix_agent']['disable_passive'] = 0
default['zabbix_agent']['disable_active'] = 0
default['zabbix_agent']['server_port'] = 10051
default['zabbix_agent']['refresh_active_checks'] = 120
default['zabbix_agent']['buffer_send'] = 5
default['zabbix_agent']['buffer_size'] = 100
default['zabbix_agent']['max_lines_per_second'] = 100
default['zabbix_agent']['allow_root'] = 0
default['zabbix_agent']['start_agents'] = 3
default['zabbix_agent']['timeout'] = 3

# You can put your extra configuration snippets in here:
default['zabbix_agent']['include_dir'] = '/etc/zabbix/zabbix_agentd.conf.d'

# This is not directly related to user_parameters; RTFM advised:
default['zabbix_agent']['allow_unsafe_user_parameters'] = 0

# Extra params for the agent to monitor
# Format: { 'key' => 'shell command', ... }
default['zabbix_agent']['user_parameters'] = {}
