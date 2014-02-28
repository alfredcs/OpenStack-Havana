#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "nova"
description "Provisions all of Nova on a node"
run_list( "role[nova_controller]",
          "role[nova_compute]" )
override_attributes({ :nova => {
	                      :zmq_matchmaker_ring => {
	                      	  "scheduler" => [ "localhost" ],
	                      	  "compute" => [ "localhost" ],
	                      	  "network" => [ "localhost" ],
	                      	  "volume" => [ "localhost" ],
	                      	  "cert" => [ "localhost" ],
	                      	  "console" => [ "localhost" ]
                        }
                      }})
