lvm_volume_group 'vg00' do
  physical_volumes ['/dev/sda', '/dev/sdb', '/dev/sdc']

  logical_volume 'ora_log' do
    size        '2G'
    filesystem  'xfs'
    mount_point location: '/var/oracle/logs', options: 'noatime,nodiratime'
    stripes     3
  end

  logical_volume 'ora01' do
    size        '25%VG'
    filesystem  'ext4'
    mount_point '/ora01'
    stripes     3
    mirrors     2
  end

  logical_volume 'ora02' do
    size        '25%VG'
    filesystem  'ext4'
    mount_point '/ora02'
    stripes     3
    mirrors     2
  end
end
