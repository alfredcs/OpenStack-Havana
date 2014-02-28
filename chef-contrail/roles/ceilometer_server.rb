#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2013 The Cloudscaling Group, Inc.  All rights reserved.
#

name "ceilometer_server"
description "Installs Ceilometer server"

# NOTE(ewindisch): these recipes could be deployed independently,
#                  if desired, but we're deploying this role as an
#                  "all-in-one" ceilometer backend.
run_list( "role[base]",
          "recipe[ceilometer::api]",
          "recipe[ceilometer::agent_central]",
          "recipe[ceilometer::collector]")
