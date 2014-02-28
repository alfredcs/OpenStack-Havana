#
# Cloudscaling Proprietary and Confidential
#
# Copyright 2011 The Cloudscaling Group, Inc.  All rights reserved.
#

name              "users"
maintainer        "The Cloudscaling Group, Inc."
maintainer_email  "pd@cloudscaling.com"
license           "Proprietary"
description       "Manages users"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "1.2"
depends           "openssh"

recipe "users", "Manages users"

provides 'here(:destroy_user)'

grouping 'users/table',
  :title => "Users Table",
  :description => "Table of users to manage via chef"

attribute 'users/safe_shell', {}
attribute 'users/inactive', {}
attribute 'users/expire', {}
attribute 'users/create_mail_spool', {}
attribute 'users/mail_dir', {}
attribute 'users/faillog_enab', {}
attribute 'users/log_unkfail_enab', {}
attribute 'users/log_ok_logins', {}
attribute 'users/syslog_su_enab', {}
attribute 'users/syslog_sg_enab', {}
attribute 'users/ftmp_file', {}
attribute 'users/su_name', {}
attribute 'users/hushlogin_file', {}
attribute 'users/env_supath', {}
attribute 'users/env_path', {}
attribute 'users/ttygroup', {}
attribute 'users/ttyperm', {}
attribute 'users/erasechar', {}
attribute 'users/killchar', {}
attribute 'users/umask', {}
attribute 'users/pass_max_days', {}
attribute 'users/pass_min_days', {}
attribute 'users/pass_warn_age', {}
attribute 'users/login_retries', {}
attribute 'users/login_timeout', {}
attribute 'users/chfn_restrict', {}
attribute 'users/default_home', {}
attribute 'users/usergroups_enab', {}
attribute 'users/fakeshell', {}
attribute 'users/console', {}
attribute 'users/console_groups', {}
attribute 'users/md5_crypt_enab', {}
attribute 'users/encrypt_method', {}
attribute 'users/sha_crypt_min_rounds', {}
attribute 'users/sha_crypt_max_rounds', {}
attribute 'users/dshell', {}
attribute 'users/dhome', {}
attribute 'users/grouphomes', {}
attribute 'users/letterhomes', {}
attribute 'users/skel', {}
attribute 'users/first_system_uid', {}
attribute 'users/last_system_uid', {}
attribute 'users/first_system_gid', {}
attribute 'users/last_system_gid', {}
attribute 'users/first_uid', {}
attribute 'users/last_uid', {}
attribute 'users/first_gid', {}
attribute 'users/last_gid', {}
attribute 'users/usergroups', {}
attribute 'users/users_gid', {}
attribute 'users/dir_mode= 0755', {}
attribute 'users/setgid_home', {}
attribute 'users/quotauser', {}
attribute 'users/skel_ignore_regex', {}
attribute 'users/extra_groups', {}
attribute 'users/add_extra_groups', {}
attribute 'users/name_regex', {}
attribute 'users/ssh_revocation_url', {}
attribute 'users/table_first_uid', {}
attribute 'users/table_last_uid', {}
