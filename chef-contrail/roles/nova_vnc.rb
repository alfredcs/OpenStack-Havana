#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "horizon"
description "Provisions a nova_vnc node"
run_list( "recipe[nova::vnc]")
