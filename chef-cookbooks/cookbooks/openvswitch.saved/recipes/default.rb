#
# Cookbook Name:: openvswitch
# Recipe:: default
#
# Copyright 2014,  KP.org
#
# All rights reserved - Do Not Redistribute
#
pacakge 'openvswitch'

template '/etc/sysconfig/openvswitch' do
  source 	'openvswitch.erb'
  notifies	:restart, 'service[openvswith]'
end

service 'openvswitch' do
  action [:enbale, :start]
end
	
