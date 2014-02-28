#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2012 The Cloudscaling Group, Inc.  All rights reserved.
#

name "natter"
description "Setup natter service"
run_list( "role[base]",
          "recipe[quagga::natter]",
          "recipe[natter]")
