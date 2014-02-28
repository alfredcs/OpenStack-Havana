file node['haproxy']['ssl_certificate'] do
  content node['haproxy']['ssl_certificate_material']
  owner 'root'
  group 'root'
  mode 0600
  only_if { node['haproxy'].attribute?('ssl_certificate_material') }
end

file node['haproxy']['s3_ssl_certificate'] do
  content node['haproxy']['s3_ssl_certificate_material']
  owner 'root'
  group 'root'
  mode 0600
  only_if { node['haproxy'].attribute?('s3_ssl_certificate_material') }
end

template '/etc/haproxy/conf.d/openstack_ecmp.cfg' do
  source 'openstack_ecmp.cfg.erb'
end

service 'haproxy' do
  supports :reload => true
  action :reload
end
