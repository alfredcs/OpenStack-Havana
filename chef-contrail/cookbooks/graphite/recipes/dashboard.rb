include_recipe "apache2"
include_recipe "apache2::mod_python"

packages = [ "python-cairo-dev", "python-django", "python-django-tagging", "python-memcache", "python-rrdtool" ]

packages.each do |graphite_package|
  package graphite_package do
    action :install
  end
end

package "python-graphite-web"

directory "#{node['graphite']['home']}/conf" do
  recursive true
end

directory "#{node['graphite']['home']}/webapp/graphite" do
  recursive true
end

template "#{node['graphite']['home']}/conf/graphTemplates.conf" do
  mode "0644"
  source "graphTemplates.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, "service[apache2]"
end

template "#{node['graphite']['home']}/webapp/graphite/local_settings.py" do
  mode "0644"
  source "local_settings.py.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  variables(
    :home           => node["graphite"]["home"],
    :whisper_dir    => node["graphite"]["carbon"]["whisper_dir"],
    :timezone       => node["graphite"]["dashboard"]["timezone"],
    :memcache_hosts => node["graphite"]["dashboard"]["memcache_hosts"],
    :mysql_server   => node["graphite"]["dashboard"]["mysql_server"],
    :mysql_username => node["graphite"]["dashboard"]["mysql_username"],
    :mysql_password => node["graphite"]["dashboard"]["mysql_password"],
    :mysql_port     => node["graphite"]["dashboard"]["mysql_port"]
  )
  notifies :restart, "service[apache2]"
end

apache_site "000-default" do
  enable false
end

web_app "graphite" do
  template "graphite.conf.erb"
  docroot "#{node['graphite']['home']}/webapp"
  server_name "graphite"
  graphite_home node["graphite"]["home"]
end

directory "#{node['graphite']['home']}/storage/log" do
  owner node["apache"]["user"]
  group node["apache"]["group"]
  recursive true
end

directory node['graphite']['carbon']['whisper_dir'] do
  owner node["apache"]["user"]
  group node["apache"]["group"]
end

directory "#{node['graphite']['home']}/storage/log/webapp" do
  owner node["apache"]["user"]
  group node["apache"]["group"]
end

cookbook_file "#{node['graphite']['home']}/storage/graphite.db" do
  owner node["apache"]["user"]
  group node["apache"]["group"]
  action :create_if_missing
end

