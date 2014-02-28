require 'minitest/spec'
#
# Cookbook Name:: keystone
# Spec:: server 
#
# Copyright 2013, Cloudscaling Group, Inc.
#
# I used https://github.com/calavera/minitest-chef-handler/blob/master/examples/spec_examples/files/default/tests/minitest/default_test.rb while making this. Thanks.

describe_recipe 'keystone::server' do
  describe "files" do
   # The simplest assertion is that a file exists following the Chef run:
    it "creates the config file" do
      file("/etc/keystone/keystone.conf").must_exist
    end

    it "ensures that the foobar file is removed if present" do
      file("/etc/keystone/default_catalog.template").wont_exist
    end

    it "Verify that we're using db-backed keystone" do
      file('/tmp/keystone/keystone.conf').must_include 'driver = keystone.catalog.backends.sql.Catalog'
    end

  end

  describe "packages" do
    # = Checking for package install =
    it "installs my favorite pager" do
      package("less").must_be_installed
    end
  end

  describe "services" do
    # You can assert that a service must be running following the converge:
    it "runs as a daemon" do
      service("keystone").must_be_running
    end

  end

  describe "users and groups" do
    # = Users =

    # Check if a user has been created:
    it "creates a user for the daemon to run as" do
      user("keystone").must_exist
    end
  end
end
