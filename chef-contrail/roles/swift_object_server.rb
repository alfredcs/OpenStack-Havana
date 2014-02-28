#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "swift_object_server"
description "Setup a node for swift object store"

run_list( "role[base]",
          "recipe[swift::object_server]")
