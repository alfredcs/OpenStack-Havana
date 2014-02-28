#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "nova-network-core"
description "Installs requirements to run a nova network controller in a Nova cluster"
run_list( "role[base]",
          "recipe[nova::mysql_check]",
          "recipe[nova::network]",
          "recipe[nova::network_core]")

