#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "logstash"
description "Joins a node to the Logstash Cluster"
run_list( "recipe[logstash::default]")
