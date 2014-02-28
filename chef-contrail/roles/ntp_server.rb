name "ntp-server"
description "ntp server"
run_list( "recipe[ntp]" )
default_attributes :ntp => { :is_server => true }
