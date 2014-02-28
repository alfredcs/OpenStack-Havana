name             "keystone"
maintainer       "The Cloudscaling Group, Inc."
maintainer_email "rodolphe@cloudscaling.com"
license          "Apache 2.0"
description      "Installs/Configures keystone"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"
################################################################################
# Latest changes and updates. This is important for documentation.             #
#                                                                              #
# cheyenne      3/28    Applied style template.                                #
#                                                                              #
################################################################################

# The dependencies for this Cookbook ##########################################

depends "openstack_config"
depends "mysql"


################################################################################

# The Recipes in this Cookbook, and what the Recipe does #######################
# Each recipe in this section is listed alphabetically.  Please keep this list #
# in alphabetical order as new recipes are added, and old recipes are removed. #

recipe "keystone::default", "Installs keystone package from source as well as dependencies"
recipe "keystone::server", "Installs keystone server configiration, create default service users and service catalog"
recipe "keystone::test_user", "Create a test tenant, user and role for testing"

################################################################################

# The attributes in this Cookbook ##############################################
# Each attribute section is listed alphabetically.  Each attribute within a    #
# section is listed chronologically, with the newest attribute being appended  #
# to the section.  Please remember to update this file's latest changes if you #
# add/remove/modify an attribute.                                              #
#                                                                              #
# Attribute sections:                                                          #
# Credentials                                                                  #
# IP and Port association                                                      #

# Attributes: Credentials ######################################################

attribute "keystone/service_password",
  :display_name => "Keystone service password",
  :description => "Keystone service password",
  :required => "required",
  :type => "string"

attribute "keystone/service_tenant_name",
  :display_name => "Keystone service tenant name",
  :description => "Keystone service tenant name",
  :default => "service",
  :required => "required",
  :type => "string"

attribute "keystone/admin_token",
  :display_name => "Admin token for the keystone service",
  :description => "Admin token for the keystone service",
  :required => "required",
  :type => "string"

# Attributes: IP and Port association ##########################################
# When adding/removing IPs and Ports, keep the pairs together. List first the  #
# IP attribute, then the Port attribute.                                       #

attribute "keystone/keystone_ip",
  :display_name => "Public IP for the keystone service",
  :description => "Public IP for the keystone service",
  :required => "required",
  :type => "string"

attribute "keystone/public_port",
  :display_name => "Public port for the keystone service",
  :description => "Public port for the keystone service",
  :default => "5000",
  :required => "required",
  :type => "string"

attribute "keystone/admin_port",
  :display_name => "Admin port for the keystone service",
  :description => "Admin port for the keystone service",
  :default => "35357",
  :required => "required",
  :type => "string"

attribute "keystone/compute_ip",
  :display_name => "Public IP for the Nova compute service",
  :description => "Public IP for the Nova compute service",
  :required => "required",
  :type => "string"

attribute "keystone/compute_port",
  :display_name => "Public port for the Nova compute service",
  :description => "Public port for the Nova compute service",
  :default => "8774",
  :required => "required",
  :type => "string"

attribute "keystone/volume_ip",
  :display_name => "Public IP for the volume service",
  :description => "Public IP for the volume service",
  :required => "required",
  :type => "string"

attribute "keystone/catalog/db_backed",
  :display_name => "Switch for using db_backed keystone",
  :description => "Switch for using db_backed keystone",
  :required => "required",
  :default => "true",
  :type => "string"

attribute "keystone/volume_port",
  :display_name => "Public port for the volume service",
  :description => "Public port for the volume service",
  :default => "8776",
  :required => "required",
  :type => "string"

attribute "keystone/ec2_ip",
  :display_name => "Public IP for the EC2 API",
  :description => "Public IP for the EC2 API",
  :required => "required",
  :type => "string"

attribute "keystone/ec2_port",
  :display_name => "Public port for the EC2 API",
  :description => "Public port for the EC2 API",
  :default => "8773",
  :required => "required",
  :type => "string"

attribute "keystone/heat_ip",
  :display_name => "Public IP for the Heat service",
  :description => "Public IP for the Heat service",
  :required => "required",
  :type => "string"

attribute "keystone/heat_port",
  :display_name => "Public port for the Heat service",
  :description => "Public port for the Heat service",
  :default => "8004",
  :required => "required",
  :type => "string"

attribute "keystone/heat_cfn_ip",
  :display_name => "Public IP for the Heat service",
  :description => "Public IP for the Heat service",
  :required => "required",
  :type => "string"

attribute "keystone/heat_cfn_port",
  :display_name => "Public port for the Heat Cloudformation service",
  :description => "Public port for the Heat Cloudformation service",
  :default => "8002",
  :required => "required",
  :type => "string"
  
attribute "keystone/glance_ip",
  :display_name => "Public IP for the Glance service",
  :description => "Public IP for the Glance service",
  :required => "required",
  :type => "string"

attribute "keystone/glance_port",
  :display_name => "Public port for the Glance service",
  :description => "Public port for the Glance service",
  :default => "9292",
  :required => "required",
  :type => "string"

attribute "keystone/swift_ip",
  :display_name => "Public IP for the Swift service",
  :description => "Public IP for the Swift service",
  :required => "required",
  :type => "string"

attribute "keystone/swift_port",
  :display_name => "Public port for the Swift service",
  :description => "Public port for the Swift service",
  :default => "8080",
  :required => "required",
  :type => "string"

attribute "keystone/bind_host",
  :display_name => "Bind IP for the keystone service",
  :description => "Bind IP for the keystone service",
  :default => "0.0.0.0",
  :required => "required",
  :type => "string"

################################################################################
