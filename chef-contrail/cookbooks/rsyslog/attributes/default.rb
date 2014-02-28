#
# Cookbook Name:: rsyslog
# Attributes:: rsyslog
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default[:rsyslog][:additional_servers] = []
default[:rsyslog][:log_hosts] = OCS.ips_for_service('rsyslog_server') + node[:rsyslog][:additional_servers]

default[:rsyslog][:server_tcp] = true
default[:rsyslog][:server_udp] = true

default[:rsyslog][:log_dir] = "/var/log/zone_rsyslogs"

# Client protocol
default[:rsyslog][:protocol] = "tcp"

# Rsyslog normally defaults to 5, disabled if 0
default[:rsyslog][:rate_limit_interval] = 0
default[:rsyslog][:rate_limit_burst] = 200
