#
# Cookbook Name:: lvm
# Recipe::two_mount_points
#
# Related cmds
# knife node show <host_name>
# knife node run_list add <host_name> 'role[create-lvm]'
# knife node edit <host_name>
# knife node show <host_name>
# knife role edit create-lvm
# knife node edit <host_name>
# knife cookbook upload lvm
# knife cookbook test lvm
# knife role show create-lvm
#chef_type:           role
#default_attributes:
#description:         Post installation configuration for lvm to be used by applicaiton including Oracle
#env_run_lists:
#json_class:          Chef::Role
#name:                create-lvm
#override_attributes:
#run_list:
#  role[base]
#  recipe[lvm::default]
#  recipe[lvm::two_mount_points] 
#
# Copyright 2009-2014, Alfred Shen.

lvm_volume_group 'vg00' do
  physical_volumes ['/dev/sdb', '/dev/sdc']

  logical_volume 'ora_log' do
    size        '2%VG'
#    filesystem  'xfs'
    filesystem  'ext4'
    mount_point location: '/var/oracle/logs', options: 'noatime,nodiratime'
    stripes     2
  end

  logical_volume 'ora01' do
    size        '50%FREE'
    filesystem  'ext4'
    mount_point '/ora01'
#    stripes     2
#    mirrors     1
  end

  logical_volume 'ora02' do
    size        '100%FREE'
    filesystem  'ext4'
    mount_point '/ora02'
#    stripes     2
#    mirrors     1
  end
end
