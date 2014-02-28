# This will install Apache Cassandra and can be used to manage multiple clusters.

# Copyright 2013, Cloudscaling.
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

include_recipe 'rethinkdb::default'

beaver_log "substratum" do
  file "/var/log/substratum/*"
  type "substratum"
end

zone = OCS.zone(1)
rethinkdb_servers = OCS.ips_for_service('rethinkdb')
memcached_servers = OCS.ips_for_service('memcached')

rethinkdb_instance 'substratum' do
  bind OCS.app_ip(node)
  port_offset 0
end

ruby_block "update-replica-count" do
  block do
    # Will raise timeout exception if we can't connect
    OCS::Net.wait_for_port('127.0.0.1',9000)
    admin = RethinkDB::Admin::Client.new('127.0.0.1', 9000)
    count = admin.machines.count
    tables = admin.tables.map { |t| t[:id] }
    tables.each do |table|
      # We set replicas and acks to be the same to mimic sync-multimaster
      admin.set_replica_settings(table, count, count)
    end
  end
end

%w[cs-image-ubuntu-12.04 cs-chef apt-cacher-ng ntp pdnsd].each {|p| package p}

service 'pdnsd' do
  action :nothing
end

cookbook_file '/etc/default/pdnsd' do
  source 'default.pdnsd'
  mode 0644
end

template '/etc/pdnsd.conf' do
  source 'pdnsd.conf.erb'
  mode 0644
  variables(
    :root_servers => node['substratum']['pdnsd']['root_servers'],
    :custom_servers => zone['dns_nameservers']
  )
  notifies :restart, 'service[pdnsd]', :immediately
end

template '/etc/substratum/site.conf' do
  owner 'substratum'
  group 'users'
  mode 0644
  source 'site.conf.erb'
  variables(
    :zone => zone,
    :db_servers => rethinkdb_servers,
    :cache_servers => memcached_servers
  )
end


package 'substratum' do
  options "-o Dpkg::Options::='--force-confold'"
end

template '/etc/default/substratum' do
  source 'substratum.default.erb'
  mode 0644
end

service 'substratum-services' do
  action [:start, :enable]
end
