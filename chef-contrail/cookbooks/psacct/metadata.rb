name              "psacct"
maintainer        "Cloudscaling"
maintainer_email  "pd@cloudscaling.com"
license           "Proprietary"
description       "Installs and configures psacct"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0"

recipe "psacct", "Installs and configures psacct server"

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "psacct",
  :display_name => "psacct",
  :description => "Hash of psacct attributes",
  :type => "hash"

