#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "rsyslog_client"
description "A rsyslog client to push data to rsyslog server"
run_list( "role[base]",
          "recipe[rsyslog::client]" )
