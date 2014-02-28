#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "cassandra"
description "Joins a node to the Cassandra Cluster"
run_list( "recipe[cassandra::default]")
