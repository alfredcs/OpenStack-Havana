#
# Cookbook Name:: cinder
# Attributes:: default
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
# Note: Commented values are there for reference, they should NOT be defaults

default['cinder']['home'] = "/home/cinder"
default['cinder']['install'] = "/tmp/cinder"

default['cinder']['user'] = "cinder"
default['cinder']['group'] = "cinder"

default['cinder']['app_ip'] = OCS.app_ip(node)

# keystone authtoken from  api-paste.ini
default['cinder']['keystone']['admin_user'] = "cinder"
default['cinder']['keystone']['enabled'] = true


# database settings
default['cinder']['mysql']['host'] = OCS.mysql_ip
default['cinder']['mysql']['user'] = "cinder"
default['cinder']['mysql']['database'] = "cinder"

#/* start rpc driver settings

# Only if using a MatchMakerBroker or MatchMakerRing, otherwise is ignored.
# (a broker is not used by default)
default['cinder']['zmq_broker_ip'] = '127.0.0.1'

# Default to brokerless fanout using a static ring-file.
default['cinder']['zmq_matchmaker'] = 'MatchMakerFanoutRing'

# Matchmaker ring file path
default['cinder']['zmq_matchmaker_ringfile'] = '/etc/cinder/matchmaker_ring.json'

# MatchMaker ring file contents. Value in format of
# examples/cinder-zeromq-ringfile.json
default['cinder']['zmq_matchmaker_ring'] = {}

# zmq first port (will consume subsequent ~50-75 TCP ports)
default['cinder']['zmq_start_port'] = 9500

# rabbitmq settings
# set_unless.cinder.rabbit.password = secure_password
# secure_password generates new password per machine
#set_unless.cinder.rabbit.password = OCS.secure_password
#default['cinder']['rabbit']['user'] = "cinder"
#default['cinder']['rabbit']['port'] = "5672"
#default['cinder']['rabbit']['vhost'] = "/cinder"
#default['cinder']['rabbit']['host'] = "localhost"
# end rpc driver settings */

# hypervisor settings
default['cinder']['libvirt_type'] = "kvm"
default['cinder']['allow_same_net_traffic'] = false


# The hostname has a direct impact on ZeroMQ as is used
# for the return-address for all messages.
# This hostname should resolve to the same IP/interface
# as node['cinder']['zmq_bind_address']
unless node['cinder'].attribute?("zmq_bind_address")
  default['cinder']['zmq_bind_address'] = '*'
end

# shared settings
override['cinder']['user'] = "cinder"
override['cinder']['user_dir'] = "/var/lib/cinder"
default['cinder']['user_group'] = "nogroup"
default['cinder']['api'] = ""
default['cinder']['project'] = "admin"


# path settings
default['cinder']['lock_path'] = "/var/lib/cinder/tmp"
default['cinder']['logdir'] = "/var/log/cinder"
default['cinder']['state_path'] = "/var/lib/cinder"

# quota defaults
# -1 disables
default['cinder']['quota']['metadata_items']= -1
default['cinder']['quota']['cores'] = -1
default['cinder']['quota']['gigabytes'] = -1
default['cinder']['quota']['volumes'] = -1

default['cinder']['services'] = []

default['cinder']['snapshot_url'] = ""
default['cinder']['snapshot_secret_key'] = ""
default['cinder']['snapshot_access_key'] = ""
