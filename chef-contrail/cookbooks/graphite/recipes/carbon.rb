package "carbon"
package "zope.interface"

template "#{node['graphite']['home']}/conf/carbon.conf" do
  mode "0644"
  source "carbon.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  variables(
    :whisper_dir                => node["graphite"]["carbon"]["whisper_dir"],
    :line_receiver_interface    => node["graphite"]["carbon"]["line_receiver_interface"],
    :pickle_receiver_interface  => node["graphite"]["carbon"]["pickle_receiver_interface"],
    :cache_query_interface      => node["graphite"]["carbon"]["cache_query_interface"],
    :log_updates                => node["graphite"]["carbon"]["log_updates"],
    :max_cache_size             => node["graphite"]["carbon"]["max_cache_size"],
    :max_creates_per_minute     => node["graphite"]["carbon"]["max_creates_per_minute"],
    :max_updates_per_second     => node["graphite"]["carbon"]["max_updates_per_second"]
  )
  notifies :restart, "service[carbon-cache]"
end

template "#{node['graphite']['home']}/conf/storage-schemas.conf" do
  mode "0644"
  source "storage-schemas.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, "service[carbon-cache]"
end

template "#{node['graphite']['home']}/conf/storage-aggregation.conf" do
  mode "0644"
  source "storage-aggregation.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, "service[carbon-cache]"
end

execute "chown" do
  command "chown -R #{node["apache"]["user"]}:#{node["apache"]["group"]} #{node['graphite']['home']}/storage"
  only_if do
    f = File.stat("#{node['graphite']['home']}/storage")
    f.uid == 0 && f.gid == 0
  end
end

template "/etc/init/carbon-cache.conf" do
  mode "0644"
  source "carbon-cache.conf.erb"
  variables(
    :home => node["graphite"]["home"],
  )
end

service "carbon-cache" do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
end
