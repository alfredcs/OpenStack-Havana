action :monitor do
  new_resource.action.delete(:monitor)
    Chef::Log.info "Enabling Monit checks for '#{new_resource.name}'."
    template "/etc/monit/conf.d/#{new_resource.name}.conf" do
      owner "root"
      group "root"
      mode 0644
      source new_resource.template_source
      notifies :reload, 'service[monit]', :immediately
    new_resource.updated_by_last_action(true)
  end
end

=begin
 Usage:
 monit_service "ssh" do
    template_source "ssh.monit.erb"
    action [:monitor]
 end
=end
