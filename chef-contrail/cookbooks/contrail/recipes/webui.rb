include_recipe 'contrail::base'

package 'contrail-openstack-webui'

template "#{node['contrail']['config_dir']}/config.global.js" do
  source "config.global.js.erb"
end

execute "supervisor-webui restart" do
  command "service supervisor-webui restart"
end
