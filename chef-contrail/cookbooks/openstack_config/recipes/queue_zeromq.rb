#
# Cookbook Name:: openstack_config
# Recipe:: zeromq
#
# Copyright 2012, The Cloudscaling Group, Inc.
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

package "libzmq1"
package "python-zmq"

# The receiver binary is included in Nova.
# this shouldn't/won't install all of Nova,
# just the common bits necessary for this recipe.
include_recipe "nova::base"

#NOTE(jogo) this should be part of the PACKAGE
directory "/etc/nova/rootwrap.d/" do
    owner "root"
    group "root"
    mode "0440"
    action :create
    recursive true
end

# Add zmq.filters rootwrap
#NOTE(jogo) this should be part of the PACKAGE
cookbook_file "/etc/nova/rootwrap.d/zmq.filters" do
    source "zmq.filters"
    mode "0440"
end

file "/etc/init/nova-zmq-receiver.override" do
  action :delete
end

service "nova-zmq-receiver" do
  provider Chef::Provider::Service::Upstart
  action :restart
end

file node['nova']['zmq_matchmaker_ringfile'] do
  content node['nova']['zmq_matchmaker_ring'].to_hash().to_json()
  notifies :restart, "service[nova-zmq-receiver]"
end
