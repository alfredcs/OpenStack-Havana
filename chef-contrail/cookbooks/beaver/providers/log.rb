def whyrun_supported?
    true
end

action :add do
  template "#{node['beaver']['config_dir']}/#{new_resource.name}" do
    source "log_resource.erb"
    cookbook "beaver"
    variables({
      :file => new_resource.file,
      :tags => new_resource.tags,
      :type => new_resource.type,
      :exclude => new_resource.exclude
    })
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  file "#{node['beaver']['config_dir']}/#{new_resource.name}" do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end
