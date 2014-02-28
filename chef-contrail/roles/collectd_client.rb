#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "collectd_client"
description "A collectd client to push data to collectd server"
run_list( "role[base]",
          "recipe[collectd::client]",
          "recipe[collectd_plugins::default]" )
