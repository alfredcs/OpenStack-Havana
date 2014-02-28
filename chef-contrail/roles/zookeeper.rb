#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "zookeeper"
description "Joins a node to the Zookeeper Cluster"
run_list( "recipe[zookeeper::default]")
