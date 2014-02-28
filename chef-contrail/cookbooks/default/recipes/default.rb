#
# Cookbook Name:: default
# Recipe:: default
#
# Copyright 2011, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This recipe will add all of the users contained in node['users'] (which
# should be stored as flat json files) to the system. It should remove
# stale admin users but this has not been tested



## keep track of the admin users so we can remove stale admin users at
## the end
admin_users = []


## iterate through all of the users in node['users']
node['users'].each do |u|

  ## force linux home dir style
  home_dir = '/home/' + u['id']

  ## create given user
  user u['id'] do
    comment u['comment'] if u['comment']
    gid     u['gid']     if u['gid']
    shell   u['shell']   if u['shell']
    home home_dir
    manage_home true
#    supports {:manage_home => true}
  end

  # ## stupid chef is not assinging the user as the owner of their home :\
  # directory home_dir do
  #   recursive true
  #   owner u['id']
  #   group u['id']
  # end

  ## make sure that the user has a .ssh directory in their home
  directory home_dir + '/.ssh' do
    recursive true
    owner u['id']
    group u['id']
  end

  ## write each key in the ssh_keys array to the authorized_keys
  ## file with a newline appended
  file home_dir + '/.ssh/authorized_keys' do
    owner u['id']
    group u['id']
    content u['ssh_keys'].join("\n")
  end



  ## allow 'sudo su -' without password
  file File.join('/etc/sudoers.d', u['id']) do
    content "#{u['id']} ALL=NOPASSWD: ALL"
    mode '0440'
  end

  ## if user is in the admin group, save it for later so we can remove
  ## stale admin users
  admin_users << u['id'] if u['group'] == 'admin'

end if node.attribute?('users') && ! node['users'].empty?


## This will be all of the users in the admin group before the second
## pass is run
previous_admin_users = `grep ^admin:.*:.*: /etc/group | sed 's/admin:.*://'`.strip.split(',')


## This is supposed to find and remove stale admins
## TODO: verify that this works
ruby_block "find stale admin users" do

  block do
    ## remove all current admin users from the previous admin users list
    admin_users.each do |admin_user|
      previous_admin_users.delete(admin_user)
    end

    previous_admin_users.each do |stale_user|
      user stale_user do
        action :remove
      end
    end
  end
end if false
