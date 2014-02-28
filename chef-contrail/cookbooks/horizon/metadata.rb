name             "horizon"
maintainer       "cookbooks/horizon/metadata.rb"
maintainer_email "matt.joyce@cloudscaling.com"
license          "Apache 2.0"
description      "Installs/Configures horizon"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"
################################################################################
# Latest changes and updates. This is important for documentation.             #
#                                                                              #
# Created 4/2/2012
#
################################################################################

# The dependencies for this Cookbook ##########################################
depends 	"apache2"

################################################################################

# The Recipes in this Cookbook, and what the Recipe does #######################
# Each recipe in this section is listed alphabetically.  Please keep this list #
# in alphabetical order as new recipes are added, and old recipes are removed. #

recipe "horizon::default", "Installs horizon package from source as well as dependencies"

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


################################################################################
