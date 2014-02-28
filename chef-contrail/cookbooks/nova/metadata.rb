name             "nova"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures nova"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3"
################################################################################
# Latest changes and updates. This is important for documentation.             #
#                                                                              #
# cheyenne        3/28        Moved around the attributes to group them.       #
# jogo            3/28        General test and update of all attributes.       #
#                                                                              #
################################################################################

# The dependencies for this Cookbook ###########################################
supports         "ubuntu"
depends "build-essential" # unclear if still needed, but looks like yes
depends "glance"
depends "keystone"
depends "mysql"
depends "nginx" # only needed for reverse proxy
# 'openssl' exists to support generating random passwords but since these
# don't apply to multiple machines so only used by 'mysql::server' at the moment
depends "openssl"
depends "openstack_config"
depends "rabbitmq"
depends "ubuntu"
################################################################################

# The Recipes in this Cookbook, and what the Recipe does #######################
recipe "nova::api", "Installs the nova api"
recipe "nova::base", "Installs base nova support - doesn't start any services"
recipe "nova::cert", "Installs the nova cert service"
recipe "nova::compute", "Installs nova-compute"
recipe "nova::config", "configures nova.conf"
recipe "nova::demo", "Installs demo nova project"
recipe "nova::ec2compat", "Installs the nova ec2 compatibility package"
recipe "nova::flatDHCP", "Place holder for flatDHCP mode"
recipe "nova::keystone", "Place holder for keystone mode"
recipe "nova::mysql", "Installs mysql-server for use with nova"
recipe "nova::network", "Installs the nova-network; non-HA"
recipe "nova::scheduler", "Installs nova scheduler"
################################################################################

# The attributes in this Cookbook ##############################################
# Each attribute section is listed alphabetically.  Each attribute within a    #
# section is listed chronologically, with the newest attribute being appended  #
# to the section.  Please remember to update this file's latest changes if you #
# add/remove/modify an attribute.                                              #
#                                                                              #
# Attribute sections:                                                          #
# API                                                                          #
# Database                                                                     #
# Glance                                                                       #
# Heartbeat                                                                    #
# Keystone                                                                     #
# Message Queue                                                                #
# Network                                                                      #
# Proxy                                                                        #
# Scheduler                                                                    #

# Attributes:  API #############################################################

#TODO(jogo) confirm that still need this
attribute "nova/api",
  :display_name => "address of nova api endpoint",
  :description => "",
  :required => "required",
  :type => "string"

# Attributes: Database #########################################################

attribute "nova/mysql/user",
  :display_name => "mysql username for nova config",
  :description => "",
  :required => "required",
  :type => "string"

attribute "nova/mysql/password",
  :display_name => "mysql password for nova config",
  :description => "",
  :required => "required",
  :type => "string"

#TODO(jogo) make optional, add default. Blocked on db/mysql namespace
attribute "nova/mysql/database",
  :display_name => "mysql database for nova config",
  :description => "",
  :required => "required",
  :type => "string"

attribute "nova/mysql/host",
  :display_name => "mysql host ip address",
  :description => "",
  :required => "required",
  :type => "string"

# Attributes: Glance ###########################################################

#TODO(jogo) identify if this is needed with keystone
attribute "nova/glance/address",
  :display_name => "address of glance server",
  :description => "address of glance server with port. ie: 172.31.0.12:9292",
  :required => "required",
  :type => "string"

# Attributes: Keystone #########################################################

attribute "nova/keystone/service_host",
  :display_name => "IP address of nova machine",
  :description => "same as nova-api address",
  :required => "required",
  :type => "string",
  :recipes => ["nova::keystone"]

attribute "nova/keystone/auth_host",
  :display_name => "IP address of keystone server",
  :description => "",
  :required => "required",
  :type => "string",
  :recipes => ["nova::keystone"]

attribute "nova/keystone/admin_tenant_name",
  :display_name => "keystone tanant name used by nova",
  :description => "ex: service",
  :required => "required",
  :type => "string",
  :recipes => ["nova::keystone"]

attribute "nova/keystone/admin_user",
  :display_name => "keystone nova user",
  :description => "ex: nova",
  :required => "required",
  :type => "string",
  :recipes => ["nova::keystone"]

attribute "nova/keystone/admin_password",
  :display_name => "keystone nova user password",
  :description => "",
  :required => "required",
  :type => "string",
  :recipes => ["nova::keystone"]

attribute "nova/keystone/enabled",
  :display_name => "Flag to enable or disable nova-keystone",
  :description => "",
  :default => "false",
  :required => "optional",
  :type => "string",
  :recipes => ["nova::keystone"],
  :choice => [ "true", "false" ]

# Attributes: Message Queue ####################################################

attribute "nova/rpc_backend",
  :display_name => "rpc backend",
  :description => "",
  :optional => "optional",
  :type => "string"

attribute "nova/rabbit/user",
  :display_name => "rabbitmq user for nova config",
  :description => "",
  :optional => "optional",
  :type => "string"

attribute "nova/rabbit/password",
  :display_name => "rabbitmq password for nova config",
  :description => "",
  :optional => "optional",
  :default => "",
  :type => "string"

attribute "nova/rabbit/vhost",
  :display_name => "rabbitmq vhost for nova config",
  :description => "",
  :optional => "optional",
  :default => "/nova",
  :type => "string"

attribute "nova/rabbit/nodes",
  :display_name => "ip address/port pairs of rabbitmq servers for nova config",
  :description => "",
  :optional => "optional",
  :type => "string"

attribute "nova/zmq_bind_address",
  :display_name => "ip address or ethernet interface for zeromq",
  :description => "",
  :optional => "required",
  :type => "string"

attribute "nova/zmq_matchmaker_ring",
  :display_name => "matchmaker ring metadata",
  :description => "mapping of topics to destination hosts",
  :optional => "required",
  :type => "string"

attribute "nova/zmq_broker_ip",
  :display_name => "zeromq broker ip",
  :description => "broker to connect if using MatchMakerBroker",
  :optional => "optional",
  :type => "string"

attribute "nova/zmq_matchmaker",
  :display_name => "matchmaker module",
  :description => "module/class to import for matching topics to hosts.",
  :optional => "optional",
  :type => "string"

attribute "nova/zmq_matchmaker_ringfile",
  :display_name => "matchmaker ring file",
  :description => "location of the ring for ring-based MatchMakers",
  :optional => "optional",
  :type => "string"

attribute "nova/zmq_start_port",
  :display_name => "start port for zeromq listeners",
  :description => "beginning port number, will comume ~50 ports",
  :optional => "optional",
  :type => "string"

# Attributes: Network ##########################################################

attribute "nova/network",
  :display_name => "Nova network manager type",
  :description => "",
  :required => "required",
  :type => "string",
  :choice => [ "VlanManager", "FlatDHCPManager", "Layer3Manager" ]

attribute "nova/vlan_id_start",
  :display_name => "Start assigning vlans at this number",
  :description => "",
  :required => "required",
  :type => "string",
  :recipes => ["nova::demo"]

attribute "nova/routing_source_ip",
  :display_name => "nova network IP address",
  :description => "",
  :required => "optional",
  :type => "string"

attribute "nova/ip_blocks",
  :display_name => "nova ip subnets to use with vlans",
  :description => "",
  :required => "optional",
  :type => "array",
  :recipes => ["nova::demo"]
  # only needed in vlan mode

attribute "nova/num_networks",
  :display_name => "number of networks",
  :description => "",
  :required => "optional",
  :default => "1",
  :type => "string",
  :recipes => ["nova::demo"]

attribute "nova/network_size",
  :display_name => "size of network available per vlan",
  :description => "ie: 1022 for a /22",
  :required => "required",
  :type => "string",
  :recipes => ["nova::demo"]

attribute "nova/public_interface",
  :display_name => "interface name that is on the public net",
  :description => "",
  :required => "required",
  :type => "string"

attribute "nova/vlan_interface",
  :display_name => "interface name that is used for vlans",
  :description => "",
  :required => "required",
  :type => "string"

attribute "nova/fixed_range",
  :display_name => "fixed address range for flatDHCP",
  :description => "",
  :required => "optional",
  :type => "string",
  :recipes => ["nova::flatDHCP"]

attribute "nova/fixed_range_v4",
  :display_name => "fixed address range for flatDHCP",
  :description => "",
  :required => "optional",
  :type => "string",
  :recipes => ["nova::flatDHCP"]

attribute "nova/flat_interface",
  :display_name => "interface name for flatDHCP",
  :description => "",
  :required => "optional",
  :type => "string",
  :recipes => ["nova::flatDHCP"]

attribute "nova/floating_range",
  :display_name => "ip range for floating ip allocation",
  :description => "",
  :required => "optional",
  :type => "string",
  :recipes => ["nova::demo"]

 # Attributes: Scheduler ########################################################

attribute "nova/reserved_host_memory_mb",
  :display_name => "reserved host memory (mb)",
  :description => "memory allocated for base OS on compute nodes",
  :default => "3072",
  :required => "optional",
  :type => "string"

attribute "nova/cpu_allocation_ratio",
  :display_name => "CPU allocation ratio",
  :description => "2.0 means 2 VCPUs per core",
  :default => "2.0",
  :required => "optional",
  :type => "string"

################################################################################
