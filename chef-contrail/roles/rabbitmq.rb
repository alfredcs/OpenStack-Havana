#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "rabbitmq"
description "Joins a node to the RabbitMQ Cluster"
run_list("recipe[rabbitmq::default]",
         "recipe[nova::rabbitmq]")
