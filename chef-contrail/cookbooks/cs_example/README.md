Description
===========

Change ALL THE THINGS in this!

Creates clouds and makes them rain.

For general Ruby coding style guidelines look here: https://github.com/styleguide/ruby

A good Ruby cheet-sheet is here: http://zenspider.com/Languages/Ruby/QuickRef.html

It's recommended to use Foodcritic to check your recipe for goodness: http://acrmp.github.io/foodcritic/
Simply install it and run it against your cookbook directory.

* example: foodcritic cookbooks/cs_example

Recipes
=======

default
-------
The default recipe runs. Should contain stuff that is common across all recipes in this cookbook.

cloud
-----
Creates a cloud.

rain
----
Makes a cloud rain.

Resources/Providers
===================

This LWRP provides an easy way to manage additional clouds

# Actions

- :create: creates a cloud.
- :rain: Creates AND makes a cloud rain.

# Attribute Parameters

- cloud_name: name attribute. The name of the cloud to create
- stuff: some other data to make a cloud stuff.

# Example

    # Just create a cloud, don't make it rain.
    cs_example_cloud "wispy" do
      stuff "super secret stealth mode"
      action :create
    end

    # Make this one rain.
    cs_example_cloud "thunderhead" do
      stuff "rain in your face"
      action :rain
    end

Usage
=====

Put `recipe[cs_example]` in the run list.

License and Author
==================

Author:: Peon McPeerson (<peon@cloudscaling.com>)

Copyleft 2013-2086 Cloudscaling, Inc.
