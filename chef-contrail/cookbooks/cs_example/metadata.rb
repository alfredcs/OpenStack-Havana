maintainer       "Peon McPeerson"
maintainer_email "peon@cloudscaling.com"
description      "Creates clouds and makes them rain"
version          "0.0.1"
supports         "ubuntu"
depends          "ubuntu"
name             "cs_example"

attribute "cloud",
  :display_name => "cloud hash",
  :description => "Hash of cloud attributes",
  :type => "hash"

attribute "cloud/name",
  :display_name => "cloud name",
  :description => "The name of your fance fake cloud",
  :type => "string"

attribute "ip_address_of_powah",
  :display_name => "ip address of powah",
  :description => "Silly example IP is silly",
  :type => "string"
