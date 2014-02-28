#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "contrail_discovery_ha"
description "Role for setting up contrail discovery HA"
run_list( "recipe[haproxy::contrail_discovery]" )
