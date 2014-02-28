name             "substratum"
maintainer       "Joseph Glanville"
maintainer_email "joseph@cloudscaling.com"
license          "All rights reserved"
description      "Installs/Configures the Substratum datacenter manager"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"
recipe           "substratum::default", "Installs/configures Substratum."
depends          "rethinkdb"
