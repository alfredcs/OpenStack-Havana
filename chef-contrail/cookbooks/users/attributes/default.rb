# Based on Ubuntu Natty defaults & locations...

# defaults/useradd
default['users']['safe_shell'] = '/bin/sh'
default['users']['inactive'] = '-1'
default['users']['expire'] = ''
default['users']['create_mail_spool'] = 'YES'

# login.defs
default['users']['mail_dir'] = '/var/mail'
default['users']['faillog_enab'] = 'yes'
default['users']['log_unkfail_enab'] = 'no'
default['users']['log_ok_logins'] = 'no'
default['users']['syslog_su_enab'] = 'yes'
default['users']['syslog_sg_enab'] = 'yes'
#default['users']['sulog_file'] = '/var/log/sulog'
#default['users']['ttytype_file'] = '/etc/ttytype'
default['users']['ftmp_file'] = '/var/log/btmp'
default['users']['su_name'] = 'su'
default['users']['hushlogin_file'] = '.hushlogin'
default['users']['env_supath'] =
    'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
default['users']['env_path'] =
    'PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games'
default['users']['ttygroup'] = 'tty'
default['users']['ttyperm'] = '660'

# erasechar, killchar, umask MUST be strings:
default['users']['erasechar'] = '0177'
default['users']['killchar'] = '025'
default['users']['umask'] = '022'

default['users']['pass_max_days'] = 99999
default['users']['pass_min_days'] = 0
default['users']['pass_warn_age'] = 7

# Login retries is overridden by PAM settings
default['users']['login_retries'] = 5

default['users']['login_timeout'] = 60
default['users']['chfn_restrict'] = 'rwh'
default['users']['default_home'] = 'no'

#default['users']['userdel_cmd'] = '/usr/sbin/userdel_local'
default['users']['usergroups_enab'] = 'yes'
#default['users']['fakeshell'] = '/usr/bin/fakeshell'
#default['users']['console'] = "/etc/consoles"
#default['users']['console_groups'] = 'floppy:audio:cdrom'
#default['users']['md5_crypt_enab'] = 'no'
default['users']['encrypt_method'] = 'SHA512'
#node['users']['sha_crypt_min_rounds'] = 5000
#node['users']['sha_crypt_max_rounds'] = 5000

# adduser.conf
default['users']['dshell'] = '/bin/bash'
default['users']['dhome'] = '/home'
default['users']['grouphomes'] = 'no'
default['users']['letterhomes'] = 'no'
default['users']['skel'] = '/etc/skel'
default['users']['first_system_uid'] = 100
default['users']['last_system_uid'] = 999
default['users']['first_system_gid'] = 100
default['users']['last_system_gid'] = 999
default['users']['first_uid'] = 1000
default['users']['last_uid'] = 29999
default['users']['first_gid'] = 1000
default['users']['last_gid'] = 29999
default['users']['usergroups'] = 'yes'
default['users']['users_gid'] = 100
default['users']['dir_mode']= 0755
default['users']['setgid_home'] = 'no'
default['users']['quotauser'] = ''
default['users']['skel_ignore_regex'] = "dpkg-(old|new|dist|save)"
default['users']['extra_groups'] = []
default['users']['add_extra_groups'] = 0
default['users']['name_regex'] = "^[a-z][-a-z0-9_]*\$"

default['users']['ssh_revocation_url'] = nil

# The following users are managed by chef
default['users']['table_first_uid'] = default['users']['last_uid'] + 1
default['users']['table_last_uid'] = default['users']['last_uid'] * 2
default['users']['table'] = OCS.users_table

# Users Table Example:
#default['users']['table'] = {}
#    'eric' => {
#        'comments' => ''
#        'ssh_keys' => [ 'ssh-dsa ...' ]
#    }
#}
