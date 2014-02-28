# Copyright 2013, Cloudscaling Group, Inc.
# Proprietary and confidential.

# This hack makes it easier to enable the recipe.
# We'll skip doing agent config generation if this machine
# is ALSO a server as server_common also lays down a conf file.
if node['ceilometer']['agent_enabled'] == true and
 not OCS.node_has_service?(node, 'ceilometer_server')
  # when toggled via metadata.
  include_recipe "ceilometer::agent_common_stage2"
end
