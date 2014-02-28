#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name 'swift_proxy_server'
description 'Setup a node for swift proxy'
run_list( "role[base]",
          "recipe[ceilometer::agent_common]",
          "recipe[swift::proxy_server]")
