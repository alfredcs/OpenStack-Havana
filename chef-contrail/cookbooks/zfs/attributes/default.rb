default['zfs_pools'] = {}
default['sas_disks'] = nil
default['sas_enclosures'] = nil

# These settings assume the use of fast MLC SSDs. Tune both of these down for slower L2ARC.
default['zfs']['options']['l2arc_headroom'] = 16
default['zfs']['options']['l2arc_write_max'] = 200 *1024 * 1024
