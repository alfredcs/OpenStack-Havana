#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2009, Benjamin Black
# Copyright 2009-2011, Opscode, Inc.
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
require 'set'

directory "/var/lib/rabbitmq/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

file "/var/lib/rabbitmq/.erlang.cookie" do
  content node['rabbitmq']['erlang_cookie']
  owner "rabbitmq"
  group "rabbitmq"
  mode 0400
end

directory "/etc/rabbitmq/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/rabbitmq/rabbitmq-env.conf" do
  source "rabbitmq-env.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

package "rabbitmq-server"

beaver_log "rabbitmq" do
  file "/var/log/rabbitmq/*"
  type "rabbitmq"
end

service "rabbitmq-server" do
  action [:start, :enable]
end

rabbit_nodes = OCS.machines_by_role('rabbitmq')
online_nodes = rabbit_nodes.select do |m|
  m['state'] == 'morphing_complete' || m['state'] == 'in_service'
end

rabbitmq_plugin 'rabbitmq_management' do
  notifies :restart, 'service[rabbitmq-server]', :immediately
end

ruby_block "join-cluster" do
  block do
    if online_nodes.count > 0
      out = `rabbitmqctl cluster_status`.split("\n")[2]
      exp = /(rabbit@[a-z0-9]*)/
      running_nodes = out.scan(exp).flatten
      if running_nodes.to_set >= online_nodes.to_set
        Chef::Log.info("RabbitMQ node is already member of cluster")
      else
        Chef::Log.info("Attempting to join RabbitMQ cluster")
        `rabbitmqctl stop_app`
        started = false
        online_nodes.each do |m|
          host = "rabbit@#{m['hostname'].split('.').first}"
          Chef::Log.info("Trying to join to #{host}")
          join = `rabbitmqctl join_cluster #{host}`
          if $? == 0
            Chef::Log.info("Joined RabbitMQ clustter successfully")
            `rabbitmqctl start_app`
            started = true
            break
          else
            if join =~ /already clustered/
              Chef::Log.info("Node reports we were already clustered... updating")
              `rabbitmqctl update_cluster_nodes #{host}`
              `rabbitmqctl start_app`
              started = true
              break
            end
            Chef::Log.info("Failed to cluster with #{host}, trying next server")
          end
        end
        unless started
          # TODO(jpg) decide better behavior..
          Chef::Log.info("Failed to join with dany servers.. :(")
          `rabbitmqctl start_app`
        end
      end
    else
      Chef::Log.info("We are the bootstrap node, skipping cluster join")
    end
  end
end

rabbitmq_user "guest" do
    action :delete
end
