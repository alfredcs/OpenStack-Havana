name             "rethinkdb"
maintainer       "Joseph Glanville"
maintainer_email "joseph@cloudscaling.com"
license          "All rights reserved"
description      "Installs/Configures the RethinkDB distributed database"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.7"
recipe           "rethinkdb::default", "Installs/configures RethinkDB."
