#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "nova-controller"
description "Provisions a Nova Controller node"
run_list( "recipe[nova::network]",
          "role[collectd_client]",
          "role[nova_api]",
          "role[nova_cert]",
          "recipe[nova::ec2compat]",
          "recipe[nova::network]",
          "recipe[nova::network_core]",
          "recipe[nova::scheduler]",
          "recipe[nova::tools]")
