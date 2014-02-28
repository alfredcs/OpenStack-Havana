#
# Cookbook Name:: nova
# Recipe:: base
#
# Copyright 2010-2011, Opscode, Inc.
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

package "openssl"
package "openssh-client"

#other dependencies (including nova-compute dependencies)
%w{ qemu-common nova-common python-novaclient euca2ools unzip nova-doc }.each do |pkg|
  package pkg do
    options "-o Dpkg::Options::='--force-confnew'"
  end
end

#give nova user a shell
user "nova" do
  shell "/bin/bash"
end

#create nova_sudoers
cookbook_file "/etc/sudoers.d/nova_sudoers" do
  source "nova_sudoers"
  mode "0440"
end

beaver_log "nova" do
  file "/var/log/nova/*"
  type "nova"
end
