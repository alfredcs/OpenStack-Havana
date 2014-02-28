if OCS.service_enabled?('contrail_config')
  template '/etc/haproxy/conf.d/contrail_web.cfg' do
    source 'simple_backend.erb'
    variables({
      name: 'contrail_web',
      port: 8143,
      role: 'contrail_config',
    })
  end

  service 'haproxy' do
    supports :reload => true
    action :reload
  end
end
