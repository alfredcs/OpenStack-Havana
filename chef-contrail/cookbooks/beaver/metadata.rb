name             "beaver"
maintainer       "Joseph Glanville"
maintainer_email "joseph@cloudscaling.com"
license          "All rights reserved"
description      "Installs/Configures the Beaver log shipper"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.7"
recipe           "beaver::default", "Installs/configures Beaver."
