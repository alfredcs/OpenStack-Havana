cookbook_file "/usr/bin/glance-sync" do
  source "glance-sync"
  mode 0755
  only_if { node['glance']['default_store'] == 'file' }
end

template "/var/lib/glance/glance-sync.sh" do
  source "glance-sync.sh.erb"
  mode 0755
  only_if { node['glance']['default_store'] == 'file' }
end

cron "glance-sync" do
  minute "*"
  hour "*"
  day "*"
  month "*"
  command "/var/lib/glance/glance-sync.sh"
  only_if { node['glance']['default_store'] == 'file' }
end

template "/etc/init/glance-api.conf" do
  source "glance-api.erb"
  mode 0644
end
