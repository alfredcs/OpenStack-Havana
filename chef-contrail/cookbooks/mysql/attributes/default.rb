#
# Cookbook Name:: mysql
# Attributes:: server
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['mysql']['bind_address'] = OCS.app_ip(node)
default['mysql']['data_dir'] = "/var/lib/mysql"
default['mysql']['host'] = OCS.mysql_ip
default['mysql']['port'] = 3306
default['mysqld']['port'] = 3306
default['mysql']['check_port'] = 9222
default['mysql']['gcomm_port'] = 4567

mysql_nodes = OCS.machines_by_role('mysql')
online_nodes = mysql_nodes.select do |m|
  (node['application_ip'] != m['application_ip']) && (m['state'] == 'morphing_complete' || m['state'] == 'in_service')
end.count

# We need to special case the bootstrap node.
default['mysql']['bootstrap'] = online_nodes < 1 ? true : false
default['mysql']['nodes'] = mysql_nodes.map {|m| m['application_ip']}.reject do |ip|
  ip == OCS.app_ip(node)
end.join(',')

# We also need to special case single node clusters
default['mysql']['standalone'] = mysql_nodes.count == 1 ? true : false

default['mysql']['conf_dir'] = '/etc/mysql'
default['mysql']['socket'] = "/var/run/mysqld/mysqld.sock"
default['mysql']['pid_file'] = "/var/run/mysqld/mysqld.pid"
default['mysql']['old_passwords'] = 0
default['mysql']['wsrep_slave_threads'] = (node['cpu']['total']*2).to_i

wsrep_provider_options = [
  "gcache.size=4G",
  "gcache.page_size=1G",
  "gmcast.listen_addr=tcp://#{node['mysql']['bind_address']}:#{node['mysql']['gcomm_port']}"
]
if mysql_nodes.count < 3
  wsrep_provider_options << "pc.ignore_sb=true"
end
default['mysql']['wsrep_provider_options'] = wsrep_provider_options.join(';')

default['mysql']['allow_remote_root'] = true

default['mysql']['key_buffer'] = "256M"
default['mysql']['max_allowed_packet'] = "16M"
default['mysql']['max_heap_table_size'] = "300M"
default['mysql']['myisam_sort_buffer_size'] = "512M"
default['mysql']['net_read_timeout'] = "3600"
default['mysql']['net_write_timeout'] = "3600"
default['mysql']['read_buffer'] = "1M"
default['mysql']['sort_buffer'] = "4M"
default['mysql']['table_cache'] = "256"
default['mysql']['table_open_cache'] = "256"
default['mysql']['thread_cache'] = "128"
default['mysql']['thread_cache_size'] = "64"
default['mysql']['thread_concurrency'] = "16"
default['mysql']['thread_stack'] = "1024K"
default['mysql']['read_rnd_buffer_size'] = "8M"
default['mysql']['wait_timeout'] = "3600"
default['mysql']['connect_timeout'] = "3600"
default['mysql']['interactive_timeout'] = "3600"
default['mysql']['max_connections'] = "4096"

default['mysql']['myisam_recover'] = "BACKUP"
default['mysql']['back_log'] = "128"
default['mysql']['myisam_max_sort_file_size'] = "100G"

default['mysql']['query_cache_limit'] = "512M"
default['mysql']['query_cache_size'] = "512M"

default['mysql']['log_slow_queries'] = "/var/log/mysql/mysql-slow.log"
default['mysql']['long_query_time'] = 0.5
default['mysql']['long_query_no_index'] = false

default['mysql']['expire_logs_days'] = 10
default['mysql']['max_binlog_size'] = "100M"

total_mem = node['memory']['total'][0..-3].to_i / 1024
buffer_pool = total_mem / 10
add_mem = buffer_pool / 3

default['mysql']['innodb_buffer_pool_size'] = "#{buffer_pool}M"
default['mysql']['innodb_additional_mem_pool_size'] = "#{add_mem}M"

default['mysql']['skip_name_resolve'] = true
