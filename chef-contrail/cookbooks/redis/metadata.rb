name             "redis"
maintainer       "Joseph Glanville"
maintainer_email "joseph@cloudscaling.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.4"
description      "Redis: a fast, flexible datastore offering an extremely useful set of data structure primitives"
recipe           "redis::default",                     "Installs Redis."
