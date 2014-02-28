# Machine metadata
# { "id": "####-##-##",
#   ...
#   "traits": {
#     "megaraid": {
#       "0": {
#         "alarm_enabled": true,
#         ...
#       },
#       "1": {
#         "alarm_enabled": false,
#         ...
#       }
#     }

if node.attribute?("megaraid")
  cmd = '/opt/MegaRAID/MegaCli/Megacli64'
  node['megaraid'].each do |card_num, cfg|
    if cfg.attribute?("alarm_enabled")
      if OCS.truthy?(cfg.alarm_enabled)
        execute "enable-alarm_#{card_num}" do
          user 'root'
          command "#{cmd} -AdpSetProp AlarmEnbl -a#{card_num}"
        end
      else
        execute "disable-alarm_#{card_num}" do
          user 'root'
          command "#{cmd} -AdpSetProp AlarmDsbl -a#{card_num}"
        end
      end
    end
  end
end
