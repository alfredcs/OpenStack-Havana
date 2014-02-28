name              "openssh"
maintainer        "The Cloudscaling Group, Inc."
maintainer_email  "pd@cloudscaling.com"
license           "Apache 2.0"
description       "Installs & maintains openssh; Based on Opscode cookbook"
version           "1.2"

recipe "openssh", "Installs openssh"

%w{ redhat centos fedora ubuntu debian arch scientific }.each do |os|
  supports os
end

depends "iptables"

provides 'here(:authorized_keys)'

attribute 'openssh',
  :display_name => 'OpenSSH Daemon Options',
  :description => 'verbatim options for sshd_options file',
  :type => 'hash',
  :required => 'optional'
