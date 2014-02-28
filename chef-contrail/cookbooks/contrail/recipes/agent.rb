include_recipe 'contrail::base'

package 'contrail-openstack-vrouter'

bash "depmod-because-contrail-packaging-broken" do
  code "depmod -a"
end

cookbook_file "/etc/init/contrail-vrouter.conf" do
  source "contrail-vrouter.conf"
  mode 0644
end

service "contrail-vrouter" do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

cookbook_file "/etc/contrail/vif-helper" do
  mode 0755
  source "vif-helper"
end

template node['contrail']['agent']['config_file'] do
  source "agent.conf.erb"
  notifies :restart, 'service[contrail-vrouter]'
end

kernel_module "vrouter" do
  action :install
end

ruby_block "transform-network-interfaces" do
  block do
    dev = node['contrail']['agent']['eth_port']
    vhost = node['contrail']['agent']['vhost']

    lines = File.readlines('/etc/network/interfaces')

    cur_iface = nil
    ifaces = {}
    autolist = []

    lines.each do |line|
      cur_iface = line.rstrip if line.start_with?('iface')
      ifaces[cur_iface] ||= [] if cur_iface
      autolist << line if line.start_with?('auto')
      if line.start_with?("\t")
        ifaces[cur_iface] << line.rstrip
      end
    end

    # Get the target interface
    target_name = "iface #{dev} inet static"
    target_def = ifaces[target_name]
    target_mac = target_def.select {|p| p.include? 'hwaddress'}.first.split(' ').last.rstrip

    # Pull out the properties we need, remove from target
    properties = [/^dns/,/^address/,/^pre-up/,/^post-up/,/^network_name/,/^gateway/,/netmask/]
    regex = Regexp.union(properties)
    extracted_properties = target_def.select {|p| regex.match p.lstrip }

    # Work around for vrouter not supporting layered teardown of virtual devices
    # Work around for vrouter not setting promisc whilst needing it
    target_setup = [
      "\tpost-up ip link set #{dev} promisc on",
      "\tpost-up /etc/contrail/vif-helper add #{dev} #{target_mac} physical",
      "\tpre-down /etc/contrail/vif-helper delete #{dev}"
    ]

    # Create the new definition for the target interface
    new_name = "iface #{dev} inet manual"
    new_def = (target_def - extracted_properties) + target_setup

    vhost_setup = [
      "\tpre-up /etc/contrail/vif-helper create #{vhost} #{target_mac}",
      "\tpre-up /etc/contrail/vif-helper add #{vhost} #{target_mac} vhost",
      "\tpre-down /etc/contrail/vif-helper delete #{vhost}",
      "\tpost-down ip link del #{vhost}"
    ]

    # Create the definition for the vhost interface
    vhost_name = "iface #{vhost} inet static"
    vhost_def = vhost_setup + extracted_properties

    # We can now ermove the target interface from the ifaces list
    ifaces.delete(target_name)

    # Insert the new definition of the target interface
    ifaces[new_name] = new_def

    # Insert the vhost definition and add vhost to the auto list
    autolist << "auto #{vhost}\n"
    ifaces[vhost_name] = vhost_def

    output_lines = []
    ifaces.each do |k,v|
      name = k.split(' ')[1]
      output_lines << "auto #{name}" if autolist.include? "auto #{name}\n"
      output_lines << k
      output_lines += v
    end

    File.open('/etc/network/interfaces','w') do |f|
      f.write(output_lines.join("\n") + "\n")
    end
  end
  action :nothing
end

execute "start-networking" do
  command "ifup -a"
  action :nothing
end

execute "stop-networking" do
  command "ifdown -a"
  not_if "grep #{node['contrail']['agent']['vhost']} /etc/network/interfaces"
  notifies :create, 'ruby_block[transform-network-interfaces]', :immediately
  notifies :run, 'execute[start-networking]', :immediately
  notifies :restart, 'service[contrail-vrouter]', :immediately
end
