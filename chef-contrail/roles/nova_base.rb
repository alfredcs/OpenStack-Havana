#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "nova-base"
description "Install nova components unactivated"
run_list( "role[base]", 
          "role[glance]",
          "recipe[nova::base]")
