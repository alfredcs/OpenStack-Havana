#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "contrail_webui"
description "Provisions a Contrail webui node"
run_list( "recipe[contrail::webui]")
