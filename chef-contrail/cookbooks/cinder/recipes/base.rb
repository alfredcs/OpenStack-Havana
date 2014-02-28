#
# Cookbook Name:: cinder
# Recipe:: base
#
# Copyright 2012, Cloudscaling, Inc.
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

package "cinder-common"

user "cinder" do
  shell "/bin/bash"
end

template "/etc/cinder/cinder.conf" do
  source "cinder.conf.erb"
  owner "cinder"
  group "cinder"
  mode "0440"
end

beaver_log "cinder" do
  file "/var/log/cinder/*"
  type "cinder"
end
