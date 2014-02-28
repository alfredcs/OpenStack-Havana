#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "zfs-server"
description "Provisions a zfs volume node"
run_list( "recipe[zfs::default]"
        )
