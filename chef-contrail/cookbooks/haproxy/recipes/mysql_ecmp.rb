template '/etc/haproxy/conf.d/mysql_ecmp.cfg' do
  source 'mysql.cfg.erb'
  variables({
    name: 'mysql_ecmp',
    address: node['quagga']['ospfd']['app_ecmp_ip'],
    port: node['mysql']['port']
  })
end

service 'haproxy' do
  supports :reload => true
  action :reload
end
