name             "ceilometer"
maintainer       "John Tran"
maintainer_email "jhtran@att.com"
license          "All rights reserved"
description      "Installs/Configures ceilometer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
%w{ ubuntu fedora redhat centos }.each do |os|
  supports os
end

# Removed cookbook dependencies: python, mongodb
%w{ nova mysql }.each do |dep|
  depends dep
end
