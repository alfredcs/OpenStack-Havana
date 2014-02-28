#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name "mysql"
description "Role for setting up a new MariaDB (MySQL) Galera cluster node."
run_list("recipe[mysql::server]",
        "recipe[nova::mysql]",
        "recipe[keystone::mysql]",
        "recipe[glance::mysql]",
        "recipe[cinder::mysql]",
        "recipe[quantum::mysql]",
        "recipe[collectd_plugins::mysql]"
        )
