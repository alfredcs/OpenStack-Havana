#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "nova-api"
description "enable nova-api to configure nova"
run_list( "recipe[nova::api]")
