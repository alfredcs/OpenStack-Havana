package 'haproxy'

cookbook_file '/etc/default/haproxy' do
  source 'default_haproxy'
end

template '/etc/init.d/haproxy' do
  source 'init_d_haproxy.erb'
end

template '/etc/haproxy/default.cfg' do
  source 'default.cfg.erb'
end

directory '/etc/haproxy/conf.d'

monit_service 'haproxy' do
  template_source "haproxy.monit.erb"
  action :monitor
end

service "haproxy" do
  supports :reload => true
  action [ :enable, :start ]
end
