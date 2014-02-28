#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "collectd_server"
description "A central server to collect collectd data"
run_list( "role[base]",
          "recipe[collectd::server]",
          "recipe[collectd::collectd_web]",
          "recipe[collectd_plugins]" )
