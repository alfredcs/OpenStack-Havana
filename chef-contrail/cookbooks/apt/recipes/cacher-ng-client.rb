directory '/etc/apt/apt.conf.d' do
  recursive true
end

unless OCS.node_has_service?(node, 'substratum')
  file '/etc/apt/apt.conf.d/02proxy' do
    content "Acquire::http { Proxy \"#{node['quagga']['ospfd']['app_ecmp_ip']}\"; };"
  end
end
