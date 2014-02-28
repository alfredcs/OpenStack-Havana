#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "cnode_collectd_plugins"
description "includes all recipes required to setup the plugins for Cloudscaling 'cnode' class battle-cruisers"
run_list( "role[collectd_client]")

# Disable libvirt, since displays seperate entry for each VM, doesn't scale well
#          "recipe[collectd_plugins::libvirt]")

