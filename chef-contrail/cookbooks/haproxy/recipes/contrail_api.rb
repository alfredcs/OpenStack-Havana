template '/etc/haproxy/conf.d/contrail_api.cfg' do
  source 'simple_backend_contrail.erb'
  variables({
    name: 'contrail_api',
    role: 'contrail_config',
    port: node['contrail']['api_server']['port'],
    backend_port: node['contrail']['api_server']['backend_port']
  })
end

service 'haproxy' do
  supports :reload => true
  action :reload
end
