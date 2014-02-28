#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

default['swift']['account_server']['servers'] = %{
  account-server
}
default['swift']['account_server']['secondary_servers'] = %w{
  account-auditor
  account-reaper
  account-replicator
}
