#
# SAS enumeration
# Copyright Cloudscaling
# Author: Joseph Glanville <joseph@cloudscaling.com>
#

class SASEnclosureMismatchError < StandardError
end

module SAS

  SAS_EXP = "/sys/class/sas_expander"
  SAS_DEV = "/sys/class/sas_device"
  SCSIDIR = "/sys/class/scsi_disk"

  def self.rf(*path)
    File.read(File.join(*path)).rstrip
  end

  def self.enumerate_enclosure_disks(enclosures)
    enum_disks = {}
    enclosures.to_hash.each do |e, enc|
      enc_hc = "#{enc['host']}:#{enc['channel']}"
      expander = "expander-#{enc_hc}"
      exp = File.join(SAS_EXP, expander)

      raise SASEnclosureMismatchError unless enc['model'] == rf(exp, 'product_id')
      raise SASEnclosureMismatchError unless enc['vendor'] == rf(exp, 'vendor_id')
      raise SASEnclosureMismatchError unless enc['rev'] == rf(exp, 'product_rev')

      enum_disks[e] = {}
      disk_list = []

      Dir.foreach(SAS_DEV) do |device|
        if device.split('-').first == 'end_device'
          bay = rf(SAS_DEV, device, 'bay_identifier')
          if bay == '255'
            next
          end
          hctl = device.split('-')[1] + ':0'
          dev_hc = hctl.split(':')[0,2].join(':')
          if dev_hc == enc_hc
            # In our current enc

            block = Dir.entries(File.join(SCSIDIR, hctl, 'device/block')).last
            enum_disks[e][bay.to_i] = block
          end
        else
          next
        end
      end
    end
    enum_disks
  end

end
