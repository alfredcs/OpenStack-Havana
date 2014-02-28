#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "heat_engine"
description "Provisions a heat engine node"
run_list( "role[base]",
          "recipe[heat::engine]"
        )
