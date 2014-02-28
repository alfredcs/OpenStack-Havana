# Copyright 2012, Cloudscaling.
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

default['substratum']['pdnsd']['root_servers'] = %w[
  198.41.0.4
  192.228.79.201
  128.8.10.90
]

default['substratum']['root_dir'] = '/srv/substratum/services'
default['substratum']['log_dir'] = '/var/log/substratum'
default['substratum']['enabled_services'] = %w[rest-api websocket dns dhcp tftp]
