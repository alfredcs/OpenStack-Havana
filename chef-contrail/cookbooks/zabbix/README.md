Description:
============

This cookbook installs zabbix-agent.

Requirements:
=============

Ubuntu 12.04 or newer.

Attributes:
===========

Don't forget to set:

`node['zabbix_agent']['servers'] = ["Your_zabbix_server.com","secondaryserver.com"]`

You can add additional config snippets in the directory specified by
`node['zabbix_agent']['include_dir']`. They can do things like adding
UserParameters. Or, you can add those in this role like so:

`node['zabbix_agent']['user_parameters'] = { 'key.name' => 'shell command to run',
                                       ...
                                      }`
