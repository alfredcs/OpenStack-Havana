name              "contrail"
maintainer        "Cloudscaling, Inc."
maintainer_email  "joseph@cloudscaling.com"
license           "Apache 2.0"
description       "Cookbook to setup Contrail VPC"
version           "0.99.0"
supports          "ubuntu"
recipe            "contrail::api_server", "Installs and configures the Contail API server"
recipe            "contrail::quantum", "Installs the Contail Quantum plugin"
recipe            "contrail::controller", "Installs and configures the Contail Controller"
recipe            "contrail::agent", "Installs and configures the Contail vRouter module and agent"
recipe            "contrail::analytics", "Installs and configures the Contail analytics services"
recipe            "contrail::irond", "Installs and configures the irond IF-MAP server"
recipe            "contrail::dns", "Installs and configures the Contrail DNSaaS solution"
