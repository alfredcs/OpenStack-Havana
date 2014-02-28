template '/etc/haproxy/conf.d/contrail_discovery.cfg' do
  source 'simple_backend_contrail.erb'
  variables({
    name: 'contrail_discovery',
    role: 'contrail_config',
    port: node['contrail']['discovery']['port'],
    backend_port: node['contrail']['discovery']['backend_port']
  })
end

service 'haproxy' do
  supports :reload => true
  action :reload
end
