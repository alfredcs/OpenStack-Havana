#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "substratum"
description "Provisions a Substratum node"
run_list("recipe[substratum::default]")
