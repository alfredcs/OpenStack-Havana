#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

define :virtualenv, :action => :create, :owner => "root", :group => "root", :mode => 0755 do
  vpath = params[:path] ? params[:path] : "/opt/#{params[:name]}"

  package "python-virtualenv"

  if params[:action] == :create
    # Manage the directory.
    directory vpath do
      owner params[:owner]
      group params[:group]
      mode params[:mode]
      recursive true
    end
    execute "create-virtualenv-#{vpath}" do
      command "virtualenv --distribute #{vpath}"
      not_if "test -f #{vpath}/bin/python"
    end
  elsif params[:action] == :delete
    directory vpath do
      action :delete
      recursive true
    end
  end
end
