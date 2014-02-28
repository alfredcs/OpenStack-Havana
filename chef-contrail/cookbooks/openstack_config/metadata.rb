name             "openstack_config"
maintainer       "Cloudscaling Inc."
maintainer_email "jogo@cloudscaling.com"
license          "Apache 2.0"
description      "Openstack configuration metadata"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3"
################################################################################
# Latest changes and updates. This is important for documentation.             #
#                                                                              #
# jogo          4/30   Create File                                             #
#                                                                              #
################################################################################

# The dependencies for this Cookbook ###########################################
# Note that RabbitMQ is only needed when using RabbitMQ support
supports "ubuntu"
depends "ubuntu"
depends "nova"
depends "rabbitmq"
################################################################################

# The Recipes in this Cookbook, and what the Recipe does #######################
recipe "openstack_config::queue", "Configures the message queue"
recipe "openstack_config::rabbitmq", "RabbitMQ specific configuration"
recipe "openstack_config::zeromq", "ZeroMQ specific configuration"

################################################################################

# The attributes in this Cookbook ##############################################
# Each attribute section is listed alphabetically.  Each attribute within a    #
# section is listed chronologically, with the newest attribute being appended  #
# to the section.  Please remember to update this file's latest changes if you #
# add/remove/modify an attribute.                                              #
#                                                                              #
# Attribute sections:                                                          #
# Keystone                                                                     #
# Nova                                                                         #
# Queue                                                                        #
# Database

# Attributes: Database

attribute "openstack_config/sqlalchemy/driver",
  :display_name => "SQLAlchemy DB driver",
  :description => "",
  :required => "optional",
  :type => "string",
  :default => "mysql",
  :recipes => []

# Attributes: Keystone #########################################################

attribute "openstack_config/keystone/server_ip",
  :display_name => "IP address of keystone server",
  :description => "",
  :required => "required",
  :type => "string",
  :recipes => []

attribute "openstack_config/keystone/admin_port ",
  :display_name => "admin port of keystone server",
  :description => "",
  :required => "optional",
  :default=> "35357",
  :type => "string",
  :recipes => []

attribute "openstack_config/keystone/public_port ",
  :display_name => "public port of keystone server",
  :description => "",
  :required => "optional",
  :default=> "5000",
  :type => "string",
  :recipes => []

attribute "openstack_config/keystone/admin_tenant_name",
  :display_name => "keystone tanant name",
  :description => "ex: service",
  :required => "optional",
  :default=> "service",
  :type => "string",
  :recipes => []

attribute "openstack_config/keystone/admin_password",
  :display_name => "keystone user password",
  :description => "",
  :required => "required",
  :type => "string",
  :recipes => []


# Attributes: Nova #############################################################

attribute "openstack_config/compute_ip",
  :display_name => "ip address of compute api endpoint",
  :description => "",
  :required => "required",
  :type => "string"

attribute "openstack_config/glance_ip",
  :display_name => "ip address of glance api endpoint",
  :description => "",
  :required => "required",
  :type => "string"

attribute "openstack_config/glance_port",
  :display_name => "port of glance api endpoint",
  :description => "",
  :required => "optional",
  :default=> "9292",
  :type => "string"

################################################################################

# Attributes: Queue #########################################################

attribute "openstack_config/queue/driver",
  :display_name => "Queue driver",
  :description => "",
  :required => "optional",
  :type => "string",
  :default => "zeromq",
  :recipes => []
