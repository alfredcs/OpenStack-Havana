#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "rethinkdb"
description "Provisions a RethinkDB node"
run_list("recipe[rethinkdb::default]")
