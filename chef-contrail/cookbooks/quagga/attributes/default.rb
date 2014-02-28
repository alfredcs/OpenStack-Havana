default['quagga']['password'] = "password"
default['quagga']['ospfd']['app_ecmp_area'] = "1.1.1.1"
default['quagga']['ospfd']['router_id'] = OCS.app_ip(node)
# We've been using the 5th ip in this /29 historically, we can change this.
default['quagga']['ospfd']['app_ecmp_ip'] = OCS.app_ecmp_ip
default['quagga']['ospfd']['app_ecmp_interface'] = OCS.app_iface(node)
default['quagga']['ospfd']['app_ecmp_network'] = OCS.app_ecmp_cidr
default['quagga']['ospfd']['block_app_network'] = OCS.block_app_subnet(node)
default['quagga']['ospfd']['block_app_cidr'] = OCS.block_app_cidr(node)

if OCS.node_has_service?(node, 'natter')
  default['quagga']['ospfd']['router_id'] = OCS.app_ip(node)
  default['quagga']['ospfd']['natter_edge_network'] = OCS.natter_networks(node)['edge']
  # This is the 2nd to last IP in the CIDR
  default['quagga']['ospfd']['natter_edge_cidr'] = NetAddr::CIDR.create(OCS.natter_networks(node)['edge'])
  default['quagga']['ospfd']['natter_edge_router'] = node['quagga']['ospfd']['natter_edge_cidr'].enumerate[1]
  default['quagga']['ospfd']['natter_edge_area'] = "0.0.0.254"

  default['quagga']['ospfd']['natter_core_network'] = OCS.natter_networks(node)['core']
  # This is the 2nd IP in the CIDR (first is the subnet)
  default['quagga']['ospfd']['natter_core_cidr'] = NetAddr::CIDR.create(OCS.natter_networks(node)['core'])
  default['quagga']['ospfd']['natter_core_router'] = node['quagga']['ospfd']['natter_core_cidr'].enumerate[-1 - 1]
  default['quagga']['ospfd']['natter_core_area'] = "0.0.0.0"
end
