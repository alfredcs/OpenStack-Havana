require 'mudbug'
require 'netaddr'
require 'securerandom'
require 'uri'

module OCS
  ZM = Mudbug.new('substratum')
  ZM.accept(:json)
  class << self
    def zm_ip
      ZM_IP
    end

    def zm_mgmt_ips
      ips = machines_by_role('substratum').map do |c|
        mgmt_ip(c)
      end
      ips.sort_by {|ip| ip.split('.').map{ |octet| octet.to_i} }
    end

    def zm_app_ips
      ips = machines_by_role('substratum').map do |c|
        app_ip(c)
      end
      ips.sort_by {|ip| ip.split('.').map{ |octet| octet.to_i} }
    end

    def release_version
      ZM.get("zone/1/ocs_release").fetch('ocs_release')
    end

    def services
      ZM.get("services")
    end

    # gets a service by name
    def service(name)
      ZM.get("service/#{name}")
    end

    def app_ip(node)
      node['application_ip'] ||= ZM.get("machine/#{node['id']}/application_ip").fetch('application_ip')
    end

    def mgmt_ip(node)
      node['management_ip'] ||= ZM.get("machine/#{node['id']}/management_ip").fetch('management_ip')
    end

    def app_ip_cidr(node)
      cidr = block_app_subnet(node)
      node['app_ip_cidr'] ||= "#{app_ip(node)}/#{cidr.split('/').last}"
    end

    def block_app_subnet(node)
      node['block_app_subnet'] ||= ZM.get("block/#{node['block_id']}/application_subnet").fetch('application_subnet')
    end

    def block_app_cidr(node)
      node['block_app_cidr'] ||= NetAddr::CIDR.create(block_app_subnet(node))
    end

    def app_iface(node)
      node['application_interface'] ||= ZM.get("machine/#{node['id']}/application_interface").values.first
    end

    def app_ecmp_cidr
      zone_app_net = $application_cidr || zone(1)['application_cidr']
      $app_ecmp_cidr ||= NetAddr::CIDR.create(zone_app_net).subnet(Bits: 29, Objectify: true).last
    end

    def app_ecmp_ip
      app_ecmp_cidr()[5].ip
    end

    def mgmt_subnet(block_id, node)
      node["block_#{block_id}_subnet"] ||= ZM.get("block/#{block_id}/management_subnet").fetch('management_subnet')
    end

    def mgmt_cidr(block_id, node)
      node["block_#{block_id}_cidr"] ||= NetAddr::CIDR.create(mgmt_subnet(block_id, node))
    end

    def isl_cidr
      $zone_isl_cidr ||= NetAddr::CIDR.create(OCS.zone(1)['isl_cidr'])
    end

    def mysql_ip
      "127.0.0.1"
    end

    def sql_string(node, app)
      URI::Generic.build({
        :host => node[app]['mysql']['host'],
        :port => node[app]['mysql']['port'],
        :scheme => node['openstack_config']['sqlalchemy']['driver'],
        :userinfo => "#{node[app]['mysql']['user']}:#{node[app]['mysql']['password']}",
        :path => "/#{node[app]['mysql']['database']}",
        :query => 'charset=utf8'
      }).to_s
    end

    def truthy?(val)
      if val == 0 or ["0", "false", "no"].include? val.to_s.strip.downcase
        false
      else
        !!val
      end
    end

    # If this gets used we need to possibly invalidate some node attributes that are set in this lib.
    def update_traits(model, id, data)
      traits = ZM.get("#{model}/#{id}")['traits']
      new_traits = { :traits => traits.merge(data) }
      ZM.put("#{model}/#{id}", new_traits)
    end

    def update_self(node, data)
      update_traits('machine', node['id'], data)
    end

    # Don't cache this, we always want to look this up.
    def check_state(model, id, state)
      ZM.get("#{model}/#{id}/state").values.first == state
    end

    def machines
      $all_machines ||= ZM.get("machine_map")
    end

    # Normally the node object can be used for this only use this if you KNOW you need fresh data.
    def machine(query)
      ZM.get("machine/#{query}/all_attributes")
    end

    def machines_by_design(design)
      machines.select {|m| m['design'] == design }
    end

    def machines_by_role(role)
      machines.select {|m| m['roles'].include? role}.sort_by {|m| m['id'] }
    end

    # returns complete machine record for all machines in a block
    def machines_by_block(block)
      machines.select { |m| m['block_id'] == block.to_i }
    end

    def substratum_cluster_machines
      ips = machines_by_role('substratum').map do |m|
        m['management_ip']
      end
    end

    def ips_for_service(service)
      ips = machines_by_role(service).map do |c|
        app_ip(c)
      end
      ips.sort_by {|ip| ip.split('.').map{ |octet| octet.to_i} }
    end

    def service_enabled?(service)
      !machines_by_role(service).empty?
    end

    def node_has_service?(node, service)
      node['roles'].include?(service)
    end

    def keystone_internal_endpoint(node, path="/v2.0/")
      URI::Generic.build({
          :scheme => node['openstack_config']['services']['keystone']['endpoint']['internal']['protocol'],
          :host => node['openstack_config']['services']['keystone']['endpoint']['internal']['ip'],
          :port => node['openstack_config']['services']['keystone']['endpoint']['internal']['port'].to_i,
          :path => path
        })
    end

    # Gets natter edge network by getting all natters and sorting by ID
    # then selects an edge network according to the order
    def natter_networks(node)
      if natters = machines_by_role('natter')
        if i = natters.index {|n| n['id'] == node['id']}
          node['natter_networks'].fetch((i + 1).to_s, {})
        end
      end
    end

    # This is the format the current users cookbook expects
    # we can adapt it later if needed
    def users_table
      table = {}
      users.select {|u| u['disabled'] == false }.map {|u| table[u['username']] = u}
      table
    end

    def user(query)
      users.find {|u| u['username'] == query }
    end

    def users
      $users ||= ZM.get("users")
    end

    def zone(query)
      ZM.get("zone/#{query}")
    end

    def blocks
      ZM.get("blocks")
    end

    def block(query)
      ZM.get("block/#{query}")
    end

    def blocks_by_design(design)
      blocks.select {|b| b['design'] == design }
    end

    def secure_password
      SecureRandom.hex
    end
  end
end
