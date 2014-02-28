#
# Cookbook Name:: swift
# Recipe:: default
#
# Copyright 2010-2011, Cloudscaling
#
#
# This cookbook is designed to deploy swift. This recipe includes the
# base functionality that all swift types need and more specific
# function can be applied from the other recipes in this directory


## ensure that some params are set for user-frendliness
## TODO: probally a better way to raise
raise "node['swift']['monitoring']['health_service_url'] not specified!!!" unless node['swift']['monitoring'].attribute?('health_service_url')


include_recipe 'swift::install'

beaver_log "swift" do
  file "/var/log/swift/*"
  type "swift"
end
