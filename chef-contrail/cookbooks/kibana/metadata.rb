name             "kibana"
maintainer       "Joseph Glanville"
maintainer_email "joseph@cloudscaling.com"
license          "All rights reserved"
description      "Installs/Configures the Kibana web interface for ElasticSearch/Logstash"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.7"
recipe           "kibana::default", "Installs/configures Kibana."
depends          "apache2"
