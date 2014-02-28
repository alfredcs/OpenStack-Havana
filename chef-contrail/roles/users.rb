#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "users"
description "Users: Access, Authorization, Accounting."
run_list( "recipe[openssh]",
          "recipe[users]",
          "recipe[users::tools]",
          "recipe[psacct]")
