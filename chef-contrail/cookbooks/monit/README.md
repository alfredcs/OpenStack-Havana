Description
===========

Provides monit

Recipes
=======

default
-------
Installs the monit package and starts the service

web
---
Configures and starts the monit web API

Resources/Providers
===================

This LWRP provides an easy way to wrap a service with monit checks

# Actions

- :monitor: Add monit configuration and start monitoring

# Attribute Parameters

- name: name attribute. The name of the service to handle

# Example

  monit_service "ssh" do
    template_source "ssh.monit.erb"
    action [:enable, :start, :monitor]
  end

Usage
=====

Put `recipe[monit]` in the run list.

License and Author
==================

Author:: Abhishek Chanda (<abhishek@cloudscaling.com>)
Author:: Blake Barnett (<bdb@cloudscaling.com>)

Copyright 2013 Cloudscaling, Inc.
