name              "ntp"
maintainer        "Joseph Glanville"
maintainer_email  "joseph@cloudscaling.com"
license           "Apache 2.0"
description       "Installs and configures ntp for OCS nodes"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.1"

recipe "ntp", "Installs ntp for OCS nodes, syncs time from zone manager"
