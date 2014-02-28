def whyrun_supported?
    true
end

action :add do

  rethinkdb_nodes = OCS.machines_by_role('rethinkdb')
  online_nodes = rethinkdb_nodes.select do |m|
    (node['application_ip'] != m['application_ip']) && (m['state'] == 'morphing_complete' || m['state'] == 'in_service')
  end.count
  bootstrap = online_nodes < 1 ? true : false

  join_nodes = new_resource.join || OCS.ips_for_service('rethinkdb')
  if bootstrap
    # override join nodes here, we will restore after starting service
    join_nodes = []
  end

  service 'rethinkdb' do
    action :start
  end

  template "#{node['rethinkdb']['instance_dir']}/#{new_resource.name}.conf" do
    source "instance_resource.conf.erb"
    cookbook "rethinkdb"
    variables({
      :name => new_resource.name,
      :bind => new_resource.bind,
      :join => join_nodes,
      :port_offset => new_resource.port_offset
    })
    notifies :restart, 'service[rethinkdb]', :immediately
  end


  if bootstrap
    ::File.open("#{node['rethinkdb']['instance_dir']}/#{new_resource.name}.conf", 'a') do |f|
      join_nodes = new_resource.join || OCS.ips_for_service('rethinkdb')
      join_nodes.each do |s|
        f.puts("#{s}:#{node['rethinkdb']['cluster_port'] + new_resource.port_offset}")
      end
    end
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  file "#{node['rethinkdb']['instance_dir']}/#{new_resource.name}.conf" do
    action :delete
  end
  service 'rethinkdb' do
    action :restart
  end
  new_resource.updated_by_last_action(true)
end
