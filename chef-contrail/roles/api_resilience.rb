#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "api-resilience"
description "Role for setting up pound and quagga"
run_list( "recipe[quagga::app_ecmp]",
          "recipe[haproxy::default]",
          "recipe[haproxy::openstack_ecmp]",
          "recipe[haproxy::rabbitmq_ecmp]",
          "recipe[haproxy::mysql_ecmp]",
          "recipe[haproxy::contrail_web]",
          "recipe[haproxy::elasticsearch_ecmp]",
          "recipe[haproxy::substratum_rest]",
          "recipe[haproxy::kibana]",
          "recipe[haproxy::contrail_discovery]",
          "recipe[haproxy::contrail_api]"
       )

