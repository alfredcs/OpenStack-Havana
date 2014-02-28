#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "heat"
description "Provisions a heat api node"
run_list( "role[base]",
          "recipe[heat::api]",
          "recipe[heat::api-cfn]",
          "recipe[heat::api-cloudwatch]"
        )
