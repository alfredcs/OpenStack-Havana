#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

define :glance_service do

  glance_name = "glance-#{params[:name]}"

  file "/etc/init/#{glance_name}.override" do
    action :delete
  end

  service glance_name do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
    subscribes :restart, 'template[/etc/glance/glance-api.conf'
    subscribes :restart, 'template[/etc/glance/glance-registry.conf]'
  end

end
