template '/etc/haproxy/conf.d/substratum_rest.cfg' do
  source 'substratum_rest.cfg.erb'
end

service 'haproxy' do
  supports :reload => true
  action :reload
end
