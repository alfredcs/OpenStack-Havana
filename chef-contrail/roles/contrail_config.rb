#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "contrail_config"
description "Provisions a Contrail config node"
run_list( "recipe[contrail::config]")
