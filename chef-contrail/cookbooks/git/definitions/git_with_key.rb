#
# Cookbook Name:: git
# Definition:: git_with_key
#
# Copyright 2012 The Cloudscaling Group, Inc.
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

# Standard 'git' resource with added 'ssh_key' argument.
define :git_with_key do
  package "git-core"

  directory "/root/.ssh" do
    mode 0700
  end

  file "/root/.ssh/git_deploy_key" do
    owner 'root'
    group 'root'
    mode 0400
    content params[:ssh_key]
  end

  cookbook_file '/usr/local/bin/ssh_git' do
    cookbook 'git'
    mode 0755
  end

  git params[:name] do
    repository params[:repository]
    reference params[:reference]
    ssh_wrapper '/usr/local/bin/ssh_git'
    action :sync
  end
end
