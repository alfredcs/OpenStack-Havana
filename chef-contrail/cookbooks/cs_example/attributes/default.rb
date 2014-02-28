# Attributes should be defined and accessed consistently using strings
#  - incorect: default.cs_example.cloud.name = 'wispy'
#  - correct:
default['cs_example']['cloud']['name'] = 'wispy'

# Use the OCS library located in the cloudscaling cookbook to query for
# information from Substratum, or just to use common helper methods.
# Please contribute additional helpful methods!
default['cs_example']['ip_address_of_powah'] = OCS.app_ip(node)

# Information on the node object comes from 3 places:
#   1. Cookbook attributes
#   2. Ohai (run ohai, the hash it returns gets added)
#   3. Substratum (the zone-manager REST API returns a hash formatted for chef.)
#      - example: curl http://zm/machine/z2.b0/chef_solo_attributes
#
# All three sources are merged in order, investigate each for useful data.
