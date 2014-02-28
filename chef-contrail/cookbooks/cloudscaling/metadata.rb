#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

maintainer        "Cloudscaling"
maintainer_email  "support@cloudscaling.com"
license           "Apache 2.0"
description       "Common cloudscaling pieces"
version           "0.1.0"
name              "cloudscaling"
depends           "ubuntu"

%w{ ubuntu debian }.each do |os|
  supports os
end
