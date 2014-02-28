template '/etc/haproxy/conf.d/rabbitmq_ecmp.cfg' do
  source 'tcp_simple.erb'
  variables({
    name: 'rabbitmq',
    role: 'rabbitmq',
    port: node['rabbitmq']['port']
  })
end

service 'haproxy' do
  supports :reload => true
  action :reload
end
