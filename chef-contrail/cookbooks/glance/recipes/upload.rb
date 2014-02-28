#
# Cookbook Name:: glance
# Recipe:: upload
#
# Copyright 2011 Opscode, Inc.
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

#load in the AMIs
directory "#{node['glance']['working_directory']}/images" do
  owner node['glance']['user']
  mode 0755
end

images = node['glance']['images'].to_hash

# The command to add an image.
glance_cmd = "/usr/bin/glance"

# These must be set, or glance_cmd fails
if node['glance']['keystone']['enabled']
  glance_cmd << " -I #{node['glance']['keystone']['admin_user']}"
  glance_cmd << " -K #{node['openstack_config']['services']['glance']['user']['admin']['password']}"
  glance_cmd << " -T #{node['openstack_config']['services']['glance']['user']['admin']['tenant']}"
  glance_cmd << " -N #{OCS.keystone_internal_endpoint(node)}"
end

(images.keys or []).each do |image|
  next if image == 'id'
  #get the filename of the image
  filename = image.split('/').last

  glance_upload = "#{glance_cmd} add name=#{filename} is_public=true container_format=bare disk_format=qcow2 < #{filename}"

  remote_file "#{node['glance']['working_directory']}/images/#{filename}" do
    source image
    action :create_if_missing
  end

  execute glance_upload do
    cwd "#{node['glance']['working_directory']}/images"
    user node['glance']['user']
    not_if "#{glance_cmd} index | grep #{filename}"
  end
end
