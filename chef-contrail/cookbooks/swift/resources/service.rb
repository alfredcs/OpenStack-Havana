#
# Cookbook Name:: swift
# Resources:: service
#
# Copyright 2010, Cloudscaling
#

actions :setup, :start, :stop, :restart, :reload, :build, :rebalance, :enable
default_action :setup

attribute :port, :kind_of => Integer, :required => true
attribute :workers, :kind_of => Integer, :default => 68
attribute :replicator_workers, :kind_of => Integer, :default => 10
attribute :devices, :kind_of => String
attribute :part_power, :kind_of => Integer, :default => 20
attribute :replicas, :kind_of => Integer, :default => 3
attribute :min_part_hours, :kind_of => Integer, :default => 1
