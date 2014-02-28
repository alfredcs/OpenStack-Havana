#!/usr/bin/make
#
# cs-chef makefile
#
# USAGE:
#   make test
#         Sets up chef/foodcritic/kinfe/strainer, runs cookbook linters.
#   make tarball
#         Creates a cs-chef.tar.gz archive in this directory.
#   make install
#         Installs cs-chef.tar.gz to /srv/www/

SHELL := /bin/bash
sudo_cmd ?= sudo

# Space-delimited list of cookbooks to test:
cookbooks ?= $(shell cd cookbooks; find * -maxdepth 0 -type d ! -name __attic)

# Where to deploy the tarball for production:
dest_deploy ?= /srv/www/cs-chef.tar.gz

# What to call the tarball here in this directory:
tarball_filename ?= cs-chef.tar.gz

strain_targets := $(patsubst %,strain_%,$(cookbooks))

build: clean tarball

clean:
	rm -f $(tarball_filename)
	rm -f testlogs/*

bundle:
	@if ! `which bundle >/dev/null`; then $(sudo_cmd) gem install bundler; fi
	@bundle install
	@# This is to ensure that foodcritic sees this as a cookbook repository:
	@mkdir -p certificates data_bags

$(strain_targets): bundle
	@set -o pipefail; bundle exec strainer test -x \
		-p cookbooks $(patsubst strain_%,%,$@) | ./bin/logfilter.py

test: clean bundle $(strain_targets)

tarball: $(tarball_filename)

$(tarball_filename): $(shell find roles/ cookbooks/)
	@echo -ne "-> Creating archive at $(tarball_filename)\n      "
	tar czf $(tarball_filename) --exclude='__attic' roles cookbooks

deploy: tarball
	@echo -ne "-> Installing tarball as $(dest_deploy)\n      "
	$(sudo_cmd) install -m 0666 -o root -g root -D $(tarball_filename) $(dest_deploy)

# synonyms for people who don't remember which thing is verbed here:
dist: deploy
install: deploy

.phony: deploy test bundle all clean $(strain_targets)
