#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "glance"
description "Provisions a Glance node"
run_list("recipe[glance::api]",
         "recipe[glance::registry]",
         "recipe[glance::sync]")
