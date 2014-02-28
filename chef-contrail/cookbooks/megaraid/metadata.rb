name             "megaraid"
maintainer       "The Cloudscaling Group, Inc."
maintainer_email "rick@cloudscaling.com"
license          "Apache 2.0"
description      "Allows configuration of MegaRAID cards"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"
################################################################################
# Latest changes and updates. This is important for documentation.             #
#                                                                              #
#                                                                              #
################################################################################

# The dependencies for this Cookbook ##########################################


################################################################################

# The Recipes in this Cookbook, and what the Recipe does #######################
# Each recipe in this section is listed alphabetically.  Please keep this list #
# in alphabetical order as new recipes are added, and old recipes are removed. #

recipe "megaraid::default", "Configures RAID cards"
