#
# Cookbook Name:: nova
# Recipe:: ec2compat
#
# Copyright 2011, Cloudscaling
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

#
# Matches nova flavors to EC2 flavors
#

# trivial edit.  delete this comment

include_recipe "nova::config"
include_recipe "mysql"

package('libmariadbclient-dev').run_action(:install)

chef_gem "mysql2" do
  version '0.3.14'
  action :install
  options '--no-document'
end

type_list = ['ec2_instance_types']
type_list << 'contrail_instance_types' if OCS.service_enabled?('contrail_controller')

ruby_block "create-instance-types" do
  block do
    require 'mysql2'
    conn = Mysql2::Client.new(:username => "root",
                              :password => node['mysql']['server_root_password'],
                              :database => 'nova')
    type_list.each do |list|
      node['nova'][list].each_with_index do |(name, props), idx|
        conn.query("INSERT INTO `instance_types` (
          created_at, updated_at, deleted_at, name, id, memory_mb,
          vcpus, swap, vcpu_weight, flavorid, rxtx_factor, root_gb,
          ephemeral_gb, disabled, is_public, deleted)
          VALUES ( NULL, NULL, NULL, '#{name}', #{idx + 1}, #{props['memory']},
          #{props['cpu']}, #{props['swap']}, NULL, '#{props['flavor']}',
          1, #{props['root_gb']},#{props['ephemeral_gb']},0,1,0)
          ON DUPLICATE KEY UPDATE
          name=VALUES(name),
          id=VALUES(id),
          memory_mb=VALUES(memory_mb),
          vcpus=VALUES(vcpus),
          swap=VALUES(swap),
          flavorid=VALUES(flavorid),
          root_gb=VALUES(root_gb),
          ephemeral_gb=VALUES(ephemeral_gb);"
        )
      end
    end
  end
end

execute "delete-m1.tiny" do
  command "nova-manage instance_type delete m1.tiny"
  only_if "nova flavor-show m1.tiny"
end
