#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "elasticsearch"
description "Joins a node to the ElasticSearch Cluster"
run_list( "recipe[elasticsearch::default]")
