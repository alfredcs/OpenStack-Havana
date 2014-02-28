# Address config TODO(jpg) fix this shit
default['haproxy']['metadata_address'] = '169.254.169.254'
addresses = {
  "#{OCS.app_ecmp_ip}/32" => 'haproxy private listening port',
  "#{node['haproxy']['metadata_address']}/32" => 'nova metadata server private listening port',
}
if node['haproxy'].attribute?('https_listener_ip')
  addresses["#{node['haproxy']['https_listener_ip']}/32"] = 'ssl api ip address'
end
if node['haproxy'].attribute?('https_s3_ip')
  addresses["#{node['haproxy']['https_s3_ip']}/32"] = 'ssl swift-proxy address'
end
default['haproxy']['addresses'] = addresses

# SSL
default['haproxy']['ssl_certificate'] = "/etc/haproxy/ssl.crt"
default['haproxy']['s3_ssl_certificate'] = "/etc/haproxy/s3_ssl.crt"

# Global
default['haproxy']['chroot_dir'] = '/var/lib/haproxy'
default['haproxy']['user'] = 'haproxy'
default['haproxy']['group'] = 'haproxy'

# Defaults

default['haproxy']['mode'] = 'http'
default['haproxy']['con_timeout'] = '5s'
default['haproxy']['cli_timeout'] = '1d'
default['haproxy']['srv_timeout'] = '1d'
