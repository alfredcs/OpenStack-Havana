#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "rsyslog_server"
description "A central server to collect rsyslog data"
run_list( "role[base]",
          "recipe[rsyslog::server]" )
