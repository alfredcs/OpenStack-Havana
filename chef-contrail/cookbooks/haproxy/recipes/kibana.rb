if OCS.service_enabled?('kibana')
  template '/etc/haproxy/conf.d/kibana.cfg' do
    source 'simple_backend.erb'
    variables({
      name: 'kibana',
      port: node['kibana']['bind_port'],
      role: 'kibana',
    })
  end

  service 'haproxy' do
    supports :reload => true
    action :reload
  end
end
