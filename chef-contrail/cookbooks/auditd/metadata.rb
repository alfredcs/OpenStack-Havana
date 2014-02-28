name              "auditd"
maintainer        "Cloudscaling"
maintainer_email  "pd@cloudscaling.com"
license           "Proprietary"
description       "Installs and configures auditd"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.2"

depends "users"

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "auditd",
  :display_name => "Audit subsystem",
  :description => "Hash of auditd attributes",
  :type => "hash"

attribute "auditd/buffer_size",
  :display_name => "Backlog.",
  :description => "Set max number of outstanding audit buffers.",
  :type => "string"

attribute "auditd/panic_failure",
  :display_name => "Panic on failure.",
  :description => "Panic on buffer_size overflow (or printk)",
  :type => "string"

attribute "auditd/locked",
  :display_name => "Lock settings.",
  :description => "Require reboot to change audit settings.",
  :type => "string"

attribute "auditd/rules",
  :display_name => "Ruleset",
  :description => "Auditctl rules as array of hashes",
  :type => "array"
