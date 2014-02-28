#
# Cookbook Name:: heat
# Attributes:: default
#
# Copyright 2014, Cloudscaling, Inc.
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

default['heat']['home'] = "/home/heat"
default['heat']['install'] = "/tmp/heat"

default['heat']['user'] = "heat"
default['heat']['group'] = "heat"

default['heat']['app_ip'] = OCS.app_ip(node)
default['heat']['app_host'] = "http://"+default['heat']['app_ip']
# keystone authtoken from  api-paste.ini
default['heat']['keystone']['admin_user'] = "heat"
default['heat']['keystone']['enabled'] = true

# database settings
default['heat']['mysql']['host'] = OCS.mysql_ip
default['heat']['mysql']['user'] = "heat"
default['heat']['mysql']['database'] = "heat"

default['heat']['bind_port'] = 8001
default['heat']['api_cfn_bind_port'] = 8002
default['heat']['api_cloudwatch_bind_port'] = 8003
default['heat']['api_bind_port'] = 8004

# shared settings
override['heat']['user'] = "heat"
override['heat']['user_dir'] = "/var/lib/heat"
default['heat']['user_group'] = "nogroup"
default['heat']['api'] = ""
default['heat']['project'] = "admin"

# path settings
default['heat']['lock_path'] = "/var/lib/heat/tmp"
default['heat']['logdir'] = "/var/log/heat"
default['heat']['state_path'] = "/var/lib/heat"
default['heat']['services'] = []

