# This example provider shows how you can combine chef resources into
# reusable compositions

action :rain do
  Chef::Log.info "Creating #{new_resource.cloud_name}"

  template "/etc/cloud/#{new_resource.cloud_name}.conf" do
    source "cloud_template.erb"
  end

  execute "make-it-rain" do
    command "echo 'It is raining, I promise'"
  end

  new_resource.updated_by_last_action(true)
end
