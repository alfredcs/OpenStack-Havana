#
## Cloudscaling Proprietary and Confidential
##
## Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
##
#
name "quantum"
description "Provisions the quantum controller and plugin"
run_list( "recipe[quantum::server]")
