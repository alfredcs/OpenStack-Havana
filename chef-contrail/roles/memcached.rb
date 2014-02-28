#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "memcached"
description "Provisions a memcached node"
run_list( "recipe[memcached::default]")
