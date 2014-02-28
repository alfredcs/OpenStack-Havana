template '/etc/haproxy/conf.d/elasticsearch_ecmp.cfg' do
  source 'simple_backend.erb'
  variables({
    name: 'elasticsearch',
    role: 'elasticsearch',
    port: node['elasticsearch']['http_port']
  })
end

service 'haproxy' do
  supports :reload => true
  action :reload
end
