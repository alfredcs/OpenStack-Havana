#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "base"
description "base role included by all systems"
run_list("recipe[cloudscaling]",
         "recipe[apt::cacher-ng-client]",
         "recipe[ubuntu]",
         "recipe[ntp]",
         "role[collectd_client]",
         "role[rsyslog_client]",
         "recipe[kernel]",
         "role[users]",
         "recipe[monit]",
         "recipe[beaver]")
