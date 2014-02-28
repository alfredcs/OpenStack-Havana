#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "nova-compute"
description "Installs requirements to run a Compute node in a Nova cluster"
run_list( "role[base]",
          # If enabled, ceilometer installs drivers needed for nova.
          "recipe[ceilometer::agent_common]",
          "recipe[nova::mysql_check]",
          "recipe[nova::network]",
          "recipe[nova::network_core]",
          "recipe[nova::compute]",
          "recipe[ceilometer::agent_compute]",
          "role[cnode_collectd_plugins]")
