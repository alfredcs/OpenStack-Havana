name             "zookeeper"
maintainer       "Joseph Glanville"
maintainer_email "joseph@cloudscaling.com"
license          "All rights reserved"
description      "Installs/Configures an Apache Zookeeper cluster"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.7"
recipe           "zookeeper::default", "Installs/confures Apache Zookeeper."
