#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

#provides common package installation and service management
#also assumes service restart ordering does not matter

define :nova_package do

  nova_name="nova-#{params[:name]}"
  package nova_name do
    options "--force-yes"
    action :install
  end

  service nova_name do
    if (platform?("ubuntu") && node['platform_version'].to_f >= 10.04)
      restart_command "restart #{nova_name}"
      stop_command "stop #{nova_name}"
      start_command "start #{nova_name}"
      status_command "status #{nova_name} | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
    end
    supports :status => true, :restart => true
    action [:enable, :start]
    subscribes :restart, 'template[/etc/nova/nova.conf]'
  end

end
