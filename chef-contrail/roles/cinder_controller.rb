#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "cinder_controller"
description "Provisions a cinder controller node"
run_list( "recipe[cinder::base]",
          "recipe[cinder::api]",
          "recipe[cinder::scheduler]"
        )
