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

default['beaver']['config_dir'] = '/etc/beaver/conf.d'
default['beaver']['config_file'] = '/etc/beaver/conf'
default['beaver']['transport'] = 'rabbitmq'
default['beaver']['fqdn'] = true

# Backoff from 2s to 32s
default['beaver']['respawn_delay'] = 2
default['beaver']['max_failure'] = 5
