include_recipe 'contrail::base'

package 'contrail-openstack-analytics'

cookbook_file '/etc/init/contrail-analytics.conf' do
  source 'contrail-analytics.conf'
  mode 0644
end

template "#{node['contrail']['config_dir']}/vizd_param" do
  source "vizd_param.erb"
end

template "#{node['contrail']['config_dir']}/opserver_param" do
  source "opserver_param.erb"
end

template "#{node['contrail']['config_dir']}/qe_param" do
  source "qe_param.erb"
end

template "#{node['contrail']['config_dir']}/sentinel.conf" do
  source "sentinel.conf.erb"
end

execute "supervisor-analytics restart" do
  command "service supervisor-analytics restart"
end
