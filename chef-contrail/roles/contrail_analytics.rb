#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "contrail_analytics"
description "Provisions a Contrail analytics node"
run_list( "recipe[contrail::analytics]")
