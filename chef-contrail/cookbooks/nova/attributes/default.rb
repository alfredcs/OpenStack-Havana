#
# Cookbook Name:: nova
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

include_attribute 'openstack_config'

::Chef::Node.send(:include, Opscode::OpenSSL::Password)
default['nova']['app_ip'] = OCS.app_ip(node)
default['nova']['network'] = 'Layer3Manager'

default['openstack_config']['osapi_compute_listen'] = node['nova']['app_ip']
default['openstack_config']['metadata_listen'] = node['nova']['app_ip']
default['openstack_config']['metadata_host'] = node['nova']['app_ip']
default['openstack_config']['ec2_listen'] = node['nova']['app_ip']

# keystone authtoken from  api-paste.ini
default['nova']['keystone']['admin_user'] = "nova"
default['nova']['keystone']['enabled'] = true

component_log_level = node['openstack_config']['debug'] ? "DEBUG" : "INFO"

# VNC settings
default['nova']['novncproxy']['port'] = 6080

# DEBUG logging for components
default['nova']['amqplib']['loglevel'] = component_log_level
default['nova']['sqlalchemy']['loglevel'] = component_log_level
default['nova']['boto']['loglevel'] = component_log_level
default['nova']['suds']['loglevel'] = component_log_level
default['nova']['eventletwsgi']['loglevel'] = component_log_level

# iptables settings
# these can be anything other than top and bottom
default['nova']['iptables_top_regex'] = "utop"
default['nova']['iptables_bottom_regex'] = "ubottom"

# database settings
# default['nova']['mysql']['password'] = "" MUST PROVIDE in Substratum
default['nova']['mysql']['user'] = "nova"
default['nova']['mysql']['database'] = "nova"
default['nova']['mysql']['port'] = 3306
default['nova']['mysql']['host'] = OCS.mysql_ip

#/* start rpc driver settings

# Only if using a MatchMakerBroker or MatchMakerRing, otherwise is ignored.
# (a broker is not used by default)
#default['nova']['zmq_broker_ip'] = '127.0.0.1'

# Default to brokerless fanout using a static ring-file.
#default['nova']['zmq_matchmaker'] = 'MatchMakerFanoutRing'

# Matchmaker ring file path
#default['nova']['zmq_matchmaker_ringfile'] = '/etc/nova/matchmaker_ring.json'

# MatchMaker ring file contents. Value in format of
# examples/nova-zeromq-ringfile.json
#default['nova']['zmq_matchmaker_ring'] = {
#  "notifications-debug" => [ "localhost" ],
#  "notifications-info" => [ "localhost" ],
#  "notifications-warn" => [ "localhost" ],
#  "notifications-error" => [ "localhost" ],
#  "notifications-critical" => [ "localhost" ]
#}

# zmq first port (will consume subsequent ~50-75 TCP ports)
#default['nova']['zmq_start_port'] = 9500

# rabbitmq settings
# set_unless.nova.rabbit.password = secure_password
# secure_password generates new password per machine
default['nova']['rabbit']['nodes'] = OCS.ips_for_service('rabbitmq').map {|ip| "#{ip}:5672" }.join(',')
default['nova']['rabbit']['password'] = "nova"
default['nova']['rabbit']['user'] = "nova"
default['nova']['rabbit']['vhost'] = "/nova"

# end rpc driver settings */

# hypervisor settings
default['nova']['libvirt_type'] = "kvm"
default['nova']['allow_same_net_traffic'] = false

# nova version
default['nova']['version'] = "grizzly"

# The hostname has a direct impact on ZeroMQ as is used
# for the return-address for all messages.
# This hostname should resolve to the same IP/interface
# as node['nova']['zmq_bind_address']
default['nova']['zmq_bind_address'] = '0.0.0.0'

# shared settings
override['nova']['user'] = "nova" #TODO(jogo): I think this is only used in half the recipes. Further cleanup needed
override['nova']['user_dir'] = "/var/lib/nova"
default['nova']['user_group'] = "nogroup"
default['nova']['api'] = ""
default['nova']['project'] = "admin"
default['nova']['images'] = []

# general networking defaults
default['nova']['public_interface'] = OCS.app_iface(node)
default['nova']['network_size'] = 1022
default['nova']['num_networks'] = 1

# networking defaults for Flat DHCP
# default['nova']['bridge_interface'] = "eth2"
default['nova']['bridge'] = "br100"
default['nova']['flat_network_bridge'] = nova.bridge
default['nova']['flat_injected'] = "False"
default['nova']['flat_interface'] = OCS.app_iface(node)
#default['nova']['floating_range'] = "192.168.76.128/28"
#default['nova']['fixed_range'] = "192.168.0.0/24"
#default['nova']['fixed_range_v4'] = "192.168.0.0/24"
#default['nova']['fixed_range_v6'] = "fc00::1/7"

# networking defaults for VLAN
default['nova']['vlan_interface'] = OCS.app_iface(node)
default['nova']['ip_blocks'] = ["10.3.0.0/24", "10.4.0.0/24"]

# common networking settings
default['nova']['use_ipv6'] = false
default['nova']['use_deprecated_auth'] = true

default['nova']['node_availability_zone'] = "ocs"
default['nova']['routing_source_ip'] = "10.0.0.1"

# rate limiting
default['nova']['api_rate_limit'] = false

# API workers
default['nova']['api_workers'] = 40

# path settings
default['nova']['lock_path'] = "/var/lib/nova/tmp"
default['nova']['logdir'] = "/var/log/nova"
default['nova']['state_path'] = "/var/lib/nova"
default['nova']['instances_path'] = "/var/lib/nova/instances"
default['nova']['ca_path'] = "/var/lib/nova/CA"

# quota defaults
# -1 disables
default['nova']['quota']['instances'] = -1
default['nova']['quota']['cores'] = -1
default['nova']['quota']['ram'] = -1
default['nova']['quota']['floating_ips'] = -1
default['nova']['quota']['metadata_items'] = -1
default['nova']['quota']['injected_files'] = -1
default['nova']['quota']['injected_file_content_bytes'] = -1
default['nova']['quota']['injected_file_path_bytes'] = -1
# NOTE(jogo)  leaving the following quotas as disabled for a public cloud can lead to a DoS by consuming all resources
default['nova']['quota']['security_groups'] = -1
default['nova']['quota']['security_group_rules'] = -1
default['nova']['quota']['key_pairs'] = -1

# scheduler defaults
default['nova']['scheduler']['reserved_host_memory_mb'] = 3072
default['nova']['scheduler']['cpu_allocation_ratio'] = 2.0
default['nova']['scheduler']['ram_allocation_ratio'] = 1.0
default['nova']['scheduler']['max_attempts'] = 10

# L3 plugin udhcpd settings
default['nova']['udhcpd']['domain'] = 'local'
default['nova']['udhcpd']['search'] = 'local'

# switch to select quantum or nova-network
if OCS.service_enabled?('quantum')
  default['nova']['network_mode'] = "quantum"
else
  default['nova']['network_mode'] = "nova-network"
end

default['nova']['contrail_instance_types'] = {
    'vsrx-nat' => {
        :memory => 4096,
        :cpu => 2,
        :root_gb => 40,
        :ephemeral_gb => 40,
        :swap => 0,
        :flavor => 31
    }
}

default['nova']['ec2_instance_types'] = {
  'm1.small' => {
    :memory => 1740,
    :cpu => 1,
    :root_gb => 0,
    :ephemeral_gb => 160,
    :swap => 0,
    :flavor => 11
  },
  'm1.medium' => {
    :memory => 3840,
    :cpu => 1,
    :root_gb => 0,
    :ephemeral_gb => 410,
    :swap => 0,
    :flavor => 12
  },
  'm1.large' => {
    :memory => 7680,
    :cpu => 2,
    :root_gb => 0,
    :ephemeral_gb => 850,
    :swap => 0,
    :flavor => 13,
  },
  'm1.xlarge' => {
    :memory => 15360,
    :cpu => 4,
    :root_gb => 0,
    :ephemeral_gb => 1690,
    :swap => 0,
    :flavor => 14,
  },
  't1.micro' => {
    :memory => 613,
    :cpu => 1,
    :root_gb => 0,
    :ephemeral_gb => 0,
    :swap => 0,
    :flavor => 15,
  },
  'm2.xlarge' => {
    :memory => 17510,
    :cpu => 2,
    :root_gb => 0,
    :ephemeral_gb => 420,
    :swap => 0,
    :flavor => 16,
  },
  'm2.2xlarge' => {
    :memory => 35020,
    :cpu => 4,
    :root_gb => 0,
    :ephemeral_gb => 850,
    :swap => 0,
    :flavor => 17,
  },
  'm2.4xlarge' => {
    :memory => 70041,
    :cpu => 8,
    :root_gb => 0,
    :ephemeral_gb => 1690,
    :swap => 0,
    :flavor => 18,
  },
  'c1.medium' => {
    :memory => 1740,
    :cpu => 2,
    :root_gb => 0,
    :ephemeral_gb => 350,
    :swap => 0,
    :flavor => 19,
  },
  'c1.xlarge' => {
    :memory => 7168,
    :cpu => 8,
    :root_gb => 0,
    :ephemeral_gb => 1690,
    :swap => 0,
    :flavor => 20
  }
}
