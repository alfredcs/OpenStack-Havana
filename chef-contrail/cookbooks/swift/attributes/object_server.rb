#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

default['swift']['object_server']['mount_dir'] = "/srv/node"
default['swift']['object_server']['servers'] = %{
  object-server
  container-server
  account-server
}

default['swift']['object_server']['secondary_servers'] = %w{
  object-updater
  object-replicator
  object-auditor
  container-updater
  container-replicator
  container-auditor
}
