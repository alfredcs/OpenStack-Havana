#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "cinder_volume"
description "Provisions a cinder volume node"
run_list( "role[base]",
          "role[zfs_server]",
          "recipe[cinder::volume]"
        )
