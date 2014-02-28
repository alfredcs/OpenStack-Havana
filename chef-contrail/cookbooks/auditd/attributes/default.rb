default['auditd']['buffer_size'] = 320
default['auditd']['panic_failure'] = nil
default['auditd']['locked'] = nil

default['auditd']['rules'] = [ ]

# This does NOT disable this feature.
# - If false, sends to syslog.
# - If true, sends to audisp.
default['auditd']['daemon'] = nil

'''
 Examples
'''
#default['auditd']['rules'] = [
#    {
#        :syscalls => [ 'open' ],
#        :lists => [ 'entry', 'exit' ],
#        :fields => [ 'uid=#{@uid}' ]
#    },
#    {
#        :syscalls => [ 'socket' ],
#        :lists => [ 'entry', 'exit' ],
#        :fields => [ 'uid=#{@uid}' ]
#    }
#]
