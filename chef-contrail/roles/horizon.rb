#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "horizon"
description "Provisions all of Horizon on a node"
run_list( "role[base]", "recipe[horizon::default]")
