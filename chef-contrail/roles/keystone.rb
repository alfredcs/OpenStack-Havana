#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2012 The Cloudscaling Group, Inc.  All rights reserved.
#

name "keystone"
description "setup keystone"
run_list( "role[base]",
          "recipe[keystone::server]")
