#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "kibana"
description "Runs the Kibana ElasticSearch + Logstash frontend"
run_list( "recipe[kibana::default]")
