# http://docs.opscode.com/essentials_roles_formats.html

name "zabbix_agent"
description "Zabbix agent"
run_list("recipe[zabbix::install_agent]")
