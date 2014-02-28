#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "nova-cert"
description "enable nova-cert"
run_list( "recipe[nova::cert]")
