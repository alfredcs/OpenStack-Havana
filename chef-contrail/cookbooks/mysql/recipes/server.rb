#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "mysql::client"

package 'xinetd'

directory "/var/cache/local/preseeding" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

execute "preseed mariadb-server" do
  command "debconf-set-selections /var/cache/local/preseeding/mariadb-server.seed"
  action :nothing
end

template "/var/cache/local/preseeding/mariadb-server.seed" do
  source "mariadb-server.seed.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, 'execute[preseed mariadb-server]', :immediately
end

directory "#{node['mysql']['conf_dir']}"

template "#{node['mysql']['conf_dir']}/debian.cnf" do
  source "debian.cnf.erb"
  owner "root"
  group "root"
  mode "0600"
end

directory "/var/lib/mysql" do
  owner "mysql"
  group "mysql"
  mode 0755
end

cookbook_file "/etc/init.d/mysql" do
  source "init_d_mysql"
  owner "root"
  group "root"
  mode 0755
end

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

template "#{node['mysql']['conf_dir']}/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
end

package "galera"
package "mariadb-galera-server" do
  options "-o Dpkg::Options::='--force-confold'"
end

#FIXME: No idea why preseeding broke.
sql = "UPDATE user SET password=PASSWORD('#{node['mysql']['server_root_password']}') WHERE user='root';"
bash 'force-mysql-root-password' do
  code <<-EOF
    mysql -udebian-sys-maint -p#{node['mysql']['server_debian_password']} mysql -e "#{sql}"
    mysql -udebian-sys-maint -p#{node['mysql']['server_debian_password']} mysql -e "FLUSH PRIVILEGES;"
  EOF
end

bash "bootstrap-cluster" do
  code <<-EOH
    sed -i 's/^wsrep_cluster_address.*/wsrep_cluster_address=gcomm\\:\\/\\/#{Regexp.escape(node['mysql']['nodes'])}/' #{node['mysql']['conf_dir']}/my.cnf
  EOH
  only_if {node['mysql']['bootstrap']}
  not_if {node['mysql']['standalone']}
end

template '/usr/share/mysql/chkmysqlgalera' do
  source 'chkmysqlgalera.sh.erb'
  mode 0755
end

template '/etc/xinetd.d/chkmysqlgalera' do
  source 'chkmysqlgalera.inetd.erb'
end

bash 'add-chkmysqlgalera-service' do
  code <<-EOF
  echo "chkmysqlgalera  #{node['mysql']['check_port']}/tcp" >> /etc/services
  EOF
  not_if "grep 'chkmysqlgalera  #{node['mysql']['check_port']}/tcp' /etc/services"
end

service 'xinetd' do
  action :restart
end

grants_path = "#{node['mysql']['conf_dir']}/mysql_grants.sql"

begin
  t = resources("template[#{grants_path}]")
rescue
  Chef::Log.info("Could not find previously defined grants.sql resource")
  t = template grants_path do
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    action :create
  end
end

execute "mysql-install-privileges" do
  command "/usr/bin/mysql -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }#{node['mysql']['server_root_password']} < #{grants_path}"
  action :nothing
  subscribes :run, resources("template[#{grants_path}]"), :immediately
end
