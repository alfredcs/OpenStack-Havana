#
# Cookbook Name:: swift
# Providers:: service
#
# Copyright 2010, Cloudscaling
#

action :setup do
  short_name = new_resource.name.sub(/-server/,'')

  directory "/etc/swift/#{new_resource.name}" do
    owner "swift"
    group "swift"
    recursive true
    mode 0755
  end

  template "/etc/swift/#{new_resource.name}/#{new_resource.name}-#{new_resource.port}.conf" do
    cookbook "swift"
    source "server.conf.erb"
    mode 0644
    variables(
      :type => short_name,
      :devices => new_resource.devices,
      :port => new_resource.port,
      :username => "swift",
      :workers => new_resource.workers,
      :replicator_workers => new_resource.replicator_workers,
      :health_service_url => health_service_url,
      :health_service_req_trigger => health_service_req_trigger
    )
    notifies :reload, "swift_service[#{new_resource.name}]", :immediately
    backup false
  end

  directory "/var/run/swift/#{new_resource.name}" do
    owner "swift"
    group "swift"
  end

  directory new_resource.devices do
    owner "root"
    group "root"
    not_if { new_resources.devices.nil? }
  end

  template "/etc/init.d/swift-#{new_resource.name}" do
    cookbook "swift"
    source "init-script.erb"
    mode 0755
    variables :server => new_resource.name
    backup false
  end

  new_resource.updated_by_last_action(true)
end

action :rebalance do
  short_name = new_resource.name.sub(/-server/,'')

  execute "rebalance-#{short_name}" do
    cwd "/etc/swift"
    command "/usr/local/bin/swift-ring-builder #{short_name}.builder rebalance"
    user "swift"
  end

  new_resource.updated_by_last_action(true)
end

action :start do
  short_name = new_resource.name.sub(/-server/,'')

  service "swift-#{new_resource.name}" do
    action :start
  end

  new_resource.updated_by_last_action(true)
end

action :stop do
  short_name = new_resource.name.sub(/-server/,'')

  service "swift-#{new_resource.name}" do
    action :stop
  end

  new_resource.updated_by_last_action(true)
end

action :build do
  short_name = new_resource.name.sub(/-server/,'')

  execute "build-#{new_resource.name}-ring" do
    user "swift"
    cwd "/etc/swift"
    command <<-EOS
      /usr/local/bin/swift-ring-builder #{short_name}.builder create \
          #{new_resource.part_power} #{new_resource.replicas} \
          #{new_resource.min_part_hours}
    EOS
    creates "/etc/swift/#{short_name}.builder"
  end

  execute "create-empty-#{new_resource.name}-ring" do
    user "swift"
    cwd "/etc/swift"
    command "/usr/local/bin/swift-ring-builder #{short_name}.builder write_ring"
    creates "/etc/swift/#{short_name}.ring.gz"
    only_if "test -e /etc/swift/#{short_name}.builder"
  end

  new_resource.updated_by_last_action(true)
end

action :enable do
  service "swift-#{new_resource.name}" do
    action :enable
  end

  new_resource.updated_by_last_action(true)
end



# TODO: what's the deal with the shelling out?
# isn't that running in phase 1?
# we probally want to be using execute or script resources here, at least...


action :reload do
  `/usr/local/bin/swift-init #{new_resource.name} reload`

  case new_resource.name
  when "account_server"
    `/usr/local/bin/swift-init account-auditor reload`
    `/usr/local/bin/swift-init account-replicator reload`
    `/usr/local/bin/swift-init account-reaper reload`
  when "container-server"
    `/usr/local/bin/swift-init container-auditor reload`
    `/usr/local/bin/swift-init container-replicator reload`
    `/usr/local/bin/swift-init container-updater reload`
  when "object-server"
    `/usr/local/bin/swift-init object-auditor reload`
    `/usr/local/bin/swift-init object-replicator reload`
    `/usr/local/bin/swift-init object-updater reload`
  end

  new_resource.updated_by_last_action(true)
end

action :restart do
  `/usr/local/bin/swift-init #{new_resource.name} restart`

  case new_resource.name
  when "account_server"
    `/usr/local/bin/swift-init account-auditor restart`
    `/usr/local/bin/swift-init account-replicator restart`
    `/usr/local/bin/swift-init account-reaper restart`
  when "container-server"
    `/usr/local/bin/swift-init container-auditor restart`
    `/usr/local/bin/swift-init container-replicator restart`
    `/usr/local/bin/swift-init container-updater restart`
  when "object-server"
    `/usr/local/bin/swift-init object-auditor restart`
    `/usr/local/bin/swift-init object-replicator restart`
    `/usr/local/bin/swift-init object-updater restart`
  end

  new_resource.updated_by_last_action(true)
end
