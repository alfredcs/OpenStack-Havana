#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "contrail_controller"
description "Provisions a Contrail controller node"
run_list( "recipe[contrail::controller]")
