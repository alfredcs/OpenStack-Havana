Description
===========

This cookbook contains libraries, definitions and providers to ease working
with substratum and OCS specific requirements

Recipes
=======

default
-------

Resources/Providers
===================

hosts
-----

# Actions

- add: Adds an /etc/hosts entry
- remove: Removes an /etc/hosts entry

# Attribute Parameters

- name: name attribute. The name of the /etc/hosts entry to operate on
- ip: ip attribute. The ip of the /etc/hosts entry that goes along with the name

# Example

    hosts "blah" do
      ip "1.1.1.1"
      action :add
    end

    hosts "blah" do
      ip "1.1.1.1"
      action :remove
    end

kernel_module
-------------

# Actions

- install: Installs a kernel module, loads it using modprobe and appends it to /etc/modules
- remove: Removes an installed kernel module, unloads it using rmmod and removes it from /etc/modules

# Attribute Parameters

- name: Name of the kernel module, the same name you'd use with modrobe/rmmod/lsmod

# Example

    # :install is the default action
    kernel_module "foo"

    kernel_module "foo" do
      action :remove
    end

virtualenv
----------

# Actions

- create: Creates a virtualenv, installs python-virtualenv if necessary
- delete: Deletes a virtualenv

# Attribute Parameters

- name: Name of the virtualenv, used for path unless path is given.
- path: Optional path to create the virtualenv
- owner: owner for the virtualenv directory (default: root)
- group: group owner for the virtualenv directory (default: root)
- mode: permissions for the virtualenv directory (default: 0755)

# Example

    # Creates a virtual env at /opt/blah by default
    virtualenv "blah"

    virtualenv "blah" do
      action :remove
    end

    # Be explicit and provide a path, and custom permissions
    # currently user and group must already exist
    virtualenv "foo" do
      path "/tmp/oof/foo"
      owner "oof"
      group "oof"
      mode "0700"
      action :create
    end

Usage
=====

Put `recipe[cs_example]` in the run list.

License and Author
==================

Author:: Peon McPeerson (<peon@cloudscaling.com>)

Copyleft 2013-2086 Cloudscaling, Inc.
