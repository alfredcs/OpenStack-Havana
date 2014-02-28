#!/bin/bash
cd /home/swift/swift
git fetch https://review.openstack.org/openstack/swift refs/changes/02/8402/2 && git cherry-pick FETCH_HEAD
git fetch https://review.openstack.org/openstack/swift refs/changes/88/6088/1 && git cherry-pick FETCH_HEAD
/usr/bin/python2.7 setup.py install
