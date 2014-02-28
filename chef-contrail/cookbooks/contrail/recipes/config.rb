include_recipe 'contrail::base'

package 'contrail-openstack-config'

cookbook_file '/etc/init/contrail-config.conf' do
  source 'contrail-config.conf'
  mode 0644
end

template "#{node['contrail']['config_dir']}/discovery.conf" do
 source 'discovery.conf.erb'
end

template "#{node['contrail']['config_dir']}/schema_transformer.conf" do
  source "schema_transformer.conf.erb"
end

template node['contrail']['api_server']['config_file'] do
  source "api_server.conf.erb"
end

template "#{node['contrail']['config_dir']}/svc_monitor.conf" do
  source "svc_monitor.conf.erb"
end

template "#{node['contrail']['irond']['authorization']}" do
  source "basicauthusers.properties.erb"
end

execute "unpack-cfgm-utils" do
  command "cd /opt/contrail; tar xf config_utils.tgz"
  not_if { File.exists?('/opt/contrail/utils/provision.py') }
end

execute "supervisor-config restart" do
  command "service supervisor-config restart"
end
