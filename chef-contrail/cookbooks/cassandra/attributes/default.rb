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

default['cassandra']['seeds'] = node['cassandra']['nodes']
default['cassandra']['cluster_name'] = "OCS_Cluster"
default['cassandra']['auto_bootstrap'] = false
default['cassandra']['hinted_handoff_enabled'] = true
default['cassandra']['max_hint_window_in_ms'] = 3600000
default['cassandra']['authenticator'] = "org.apache.cassandra.auth.AllowAllAuthenticator"
default['cassandra']['authority'] = "org.apache.cassandra.auth.AllowAllAuthority"
default['cassandra']['partitioner'] = "org.apache.cassandra.dht.RandomPartitioner"
default['cassandra']['data_file_directories'] =  ["/var/lib/cassandra/data"]
default['cassandra']['commitlog_directory'] = "/var/lib/cassandra/commitlog"
default['cassandra']['saved_caches_directory'] = "/var/lib/cassandra/saved_caches"
default['cassandra']['commitlog_rotation_threshold_in_mb'] = 128
default['cassandra']['commitlog_sync'] = "periodic"
default['cassandra']['commitlog_sync_period_in_ms'] = 10000
default['cassandra']['flush_largest_memtables_at'] = 0.75
default['cassandra']['reduce_cache_sizes_at'] = 0.85
default['cassandra']['reduce_cache_capacity_to'] = 0.6
default['cassandra']['seed_provider_class_name'] = "org.apache.cassandra.locator.SimpleSeedProvider"
default['cassandra']['disk_access_mode'] = "auto"
default['cassandra']['concurrent_reads'] = 80
default['cassandra']['concurrent_writes'] = 64
default['cassandra']['memtable_flush_queue_size'] = 4
default['cassandra']['memtable_flush_writers'] = 1
default['cassandra']['jmx_port'] = 7199
default['cassandra']['storage_port'] = 7000
default['cassandra']['rpc_port'] = 9160
default['cassandra']['rpc_keepalive'] = true
default['cassandra']['rpc_server_type'] = "sync"
default['cassandra']['thrift_framed_transport_size_in_mb'] = 15
default['cassandra']['thrift_max_message_length_in_mb'] = 16
default['cassandra']['incremental_backups'] = false
default['cassandra']['snapshot_before_compaction'] = false
default['cassandra']['column_index_size_in_kb'] = 64
default['cassandra']['in_memory_compaction_limit_in_mb'] = 64
default['cassandra']['compaction_throughput_mb_per_sec'] = 16
default['cassandra']['compaction_preheat_key_cache'] = true
default['cassandra']['phi_convict_threshold'] = 8
default['cassandra']['endpoint_snitch'] = "org.apache.cassandra.locator.PropertyFileSnitch"
default['cassandra']['dynamic_snitch_badness_threshold'] = 0.0
default['cassandra']['request_scheduler'] = "org.apache.cassandra.scheduler.NoScheduler"
default['cassandra']['index_interval'] = 128
default['cassandra']['memtable_total_space_in_mb'] = 4096
default['cassandra']['multithreaded_compaction'] = false
default['cassandra']['commitlog_total_space_in_mb'] = 3072
# These can be specified in metadata to fine tune Cassandra
#default['cassandra']['max_heap_size'] = "10G"
#default['cassandra']['heap_new_size'] = "800M"
