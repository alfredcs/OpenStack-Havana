#
## Cloudscaling Proprietary and Confidential
##
## Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
##
#
name "redis"
description "Provisions a Redis node"
run_list( "recipe[redis::default]",
           "recipe[redis::base]")
