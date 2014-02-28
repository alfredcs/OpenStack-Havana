template '/etc/haproxy/conf.d/mysql_local.cfg' do
  source 'mysql.cfg.erb'
  variables({
    name: 'mysql_local',
    address: '127.0.0.1',
    port: node['mysql']['port']
  })
  notifies :reload, 'service[haproxy]', :immediately
end

service 'haproxy' do
  supports :reload => true
  action [ :enable, :start ]
end
