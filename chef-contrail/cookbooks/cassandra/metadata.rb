name             "cassandra"
maintainer       "Joseph Glanville"
maintainer_email "joseph@cloudscaling.com"
license          "All rights reserved"
description      "Installs/Configures an Apache Cassandra cluster"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.7"
recipe           "cassandra::default", "Installs/confures Apache Cassandra."
