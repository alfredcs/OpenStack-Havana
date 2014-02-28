#
# Cookbook Name:: auditd
# Recipe:: default
# Author:: Eric Windisch (<eric@cloudscaling.com>)
#
# Copyright 2011, Cloudscaling

class HashScope
  def initialize(n)
    n.each do |key, val|
        self.instance_variable_set('@' + key, val)
    end
  end
  def getBinding
    return binding()
  end
end

# Build out the ruleset.
# The attributes specifies the rules,
# which require variable substitution.
# Note: I couldn't find another way to do this in Ruby(!?) --EricW
# TODO: Fixme, this is a slow and stupid way to do things. --EricW
rule_builder = lambda {
    rules = []
    node['auditd']['rules'].each do |rule|
        non_system_users.each do |username,udata|
            # We presume that 'user' is a hash with keys such as 'username', etc.
            # the attributes will reference these keys.

            # Because username is normally the key, we inject it into the hash
            udata['username'] = username

            # Provide udata as local-scope variables to fields generator.
            scope = HashScope.new(udata)
            binding = scope.getBinding
            fields = rule[:fields].to_a.map {|f|
                eval("%Q{#{f}}", binding)
            }

            # Format the rules
            rules << rule.merge({
                :fields => fields.to_a.map {|f| "-F #{f}"}.join(" "),
                :syscalls => rule[:syscalls].to_a.map {|s| "-S #{s}"}.join(" "),
            })
        end
    end
    return rules.uniq
}

# This package includes more than the daemon, but also user-space tools
# necessary to manipulate the kernel-space.
package "auditd" do
  action :install
end

template "/etc/audit/audit.rules" do
  source "audit.rules.erb"
  owner "root"
  group "root"
  mode 0640
  notifies :restart, "service[auditd]"
  variables({
    :rules => rule_builder
  })
end

#
# Daemon below. Audit rules will still work if we don't run this.
# If it doesn't run, messages go (only) to syslog.
#
template "/etc/audit/auditd.conf" do
  source "auditd.conf.erb"
  owner "root"
  group "root"
  mode 0640
  notifies :restart, "service[auditd]"
  only_if {node['auditd']['daemon']}
end

cookbook_file "/etc/audisp/plugins.d/syslog.conf" do
  source "audisp-syslog.conf"
  owner "root"
  group "root"
  mode 0640
end

service "auditd" do
  service_name node['auditd']['service']
  action [:enable, :start]
  only_if {node['auditd']['daemon']}
end
