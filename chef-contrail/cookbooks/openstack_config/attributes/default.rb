#
# Cookbook Name:: Openstack-Config
# Attributes:: default
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

# Individual service logging levels
default['openstack_config']['service']['keystone']['debug'] = true
default['openstack_config']['service']['keystone']['verbose'] = true
default['openstack_config']['service']['nova']['debug'] = true
default['openstack_config']['service']['nova']['verbose'] = true
default['openstack_config']['service']['cinder']['debug'] = true
default['openstack_config']['service']['cinder']['verbose'] = true
default['openstack_config']['service']['glance']['debug'] = true
default['openstack_config']['service']['glance']['verbose'] = true
default['openstack_config']['service']['quantum']['debug'] = true
default['openstack_config']['service']['quantum']['verbose'] = true

default['openstack_config']['debug'] = true
default['openstack_config']['verbose'] = true

#FIXME: I don't know if this breaks anything by changing it to grizzly! - bdb
default['openstack_config']['release'] = "grizzly"

default['openstack_config']['queue']['driver'] = "rabbitmq"

# This list defines mapping from simple names to modules,
# i.e. we know which module to import when the queue driver is
#      specified as 'rabbitmq' or 'zeromq'
default['openstack_config']['queue']['modules'] = {
                      "rabbitmq" => "%{project}.rpc.impl_kombu",
                      "qpid" => "%{project}.rpc.impl_qpid",
                      "zeromq" => "%{project}.rpc.impl_zmq"
                    }

default['openstack_config']['keystone']['admin_port'] = "35357"
default['openstack_config']['keystone']['public_port'] = "5000"

#default['openstack_config']['compute_ip'] = ""
default['openstack_config']['glance_port'] = "9292"
default['openstack_config']['cinder']['server_port'] = 8776

# Alternative value is "mysql+pymysql", which is slower but more
# eventlet-friendly and may have fewer edge-case quirks.
default['openstack_config']['sqlalchemy']['driver'] = "mysql"


default['openstack_config']['services']['keystone']['endpoint']['internal']['protocol'] = "http"
default['openstack_config']['services']['keystone']['endpoint']['internal']['ip'] = OCS.app_ecmp_ip
default['openstack_config']['services']['keystone']['endpoint']['internal']['port'] = "5000"
default['openstack_config']['services']['keystone']['endpoint']['internal']['version'] = "v2.0"
default['openstack_config']['services']['keystone']['endpoint']['internal']['admin_port'] = "35357"

default['openstack_config']['services']['keystone']['region'] = "RegionOne"
default['openstack_config']['services']['keystone']['user']['admin']['tenant'] = "service"
