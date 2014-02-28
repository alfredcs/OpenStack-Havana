# Copyright 2013, Cloudscaling Group, Inc.
# Proprietary and confidential.

# This hack makes it easier to enable the recipe
if node['ceilometer']['agent_enabled'] == true
  # when toggled via metadata.
  include_recipe "ceilometer::agent_compute_stage2"
end
