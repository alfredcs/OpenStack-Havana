#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "contrail_node"
description "Provisions a Contrail compute/agent node"
run_list( "recipe[contrail::agent]")
