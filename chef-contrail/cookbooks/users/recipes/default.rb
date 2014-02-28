require 'set'
include_recipe 'openssh'

template '/etc/adduser.conf' do
    source 'adduser.conf.erb'
end

#template '/etc/login.defs' do
#    source 'login.defs.erb'
#end

template '/etc/default/useradd' do
    source 'useradd.erb'
end

cookbook_file '/etc/pam.d/su' do
    mode '0644'
    owner 'root'
    source 'su'
end

ohai 'reload_passwd' do
    action :nothing
    plugin 'passwd'
end

# fixes CHEF-1699
ruby_block 'reset group list' do
    block do
        Etc.endgrent
    end
    action :nothing
end

'''
 Read users:
 - existing_managed_users are all *existing* users
   between users.table_first_uid and users.table_last_uid
 - metadata_users are all users in users.table.
 - existing_unmanaged_users are all *existing* users
   between users.first_uid and users.last_uid
'''
existing_managed_users = Set.new managed_users.keys
existing_unmanaged_users = Set.new non_managed_users.keys
metadata_users = Set.new node['users']['table'].keys
deleted_usernames = existing_managed_users - metadata_users - existing_unmanaged_users

# Useful for debugging if you run into trouble...
#log "Managed users = #{existing_managed_users.to_a.join(' ')}"
#log "Chef users = #{metadata_users.to_a.join(' ')}"
#log "Non-managed users = #{existing_unmanaged_users.to_a.join(' ')}"
#log "To-delete users = #{deleted_usernames.to_a.join(' ')}"

# Assume that we trust S3, the Amazon certificate, and this path.
# Consider JWS/JWT? http://self-issued.info/docs/draft-jones-json-web-signature.html
# Requirement for trust is weak as this recipe should not be the end-all to authentication.
delete_keys = Set.new []
if not node['users']['ssh_revocation_url'].nil?
    begin
        delete_keys = Set.new Chef::Rest.new(
            node['users']['ssh_revocation_url'], false, false
        ).get_rest('')
    rescue
        $stderr.puts "[users] ssh_revocation_url specified, but URL loading failed"
    end
end

'''
 Create, Update users
'''
# Find first unused uid
base_uid = 1 + node[:etc][:passwd].to_hash.values.max_by{|e|
    ([ node['users']['table_first_uid'].to_i, e['uid'] ].max < node['users']['table_last_uid'].to_i) ?
        e['uid'] :
        0
}['uid']

node['users']['table'].each do |username, u|
    if defined? u['disabled'] and u['disabled']
        # Delete, if this is a managed user.
        if existing_managed_users.include? username
            deleted_usernames.add(username)
        end

        next
    end

    user username do
        shell ( u['shell'] || node['users']['dshell'] )
        comment ( u['comment'] || '' )
        home ( u['home'] ||
            [ node['users']['dhome'], username ].join('/') )
        uid ( (defined? node[:etc][:passwd][username]) ? nil : base_uid += 1 )

        #FIXME: Can't handle homedirs that already exist...
        #supports :manage_home => true

        provider Chef::Provider::User::UseraddMinUID

        notifies :create, 'ruby_block[reset group list]', :immediately

        # Must be immediate, we have stuff that relies on ohai!
        notifies :reload, resources(:ohai => 'reload_passwd'), :immediately
    end

    # Admins group not necesary with sudo_access
    if defined? u['ssh_keys'] and not u['ssh_keys'].nil?
        authorized_keys username do
            # Install non-blacklisted keys
            keys u['ssh_keys'].delete_if {|k| delete_keys.include?(k)}
            action :create
        end
    end

    if defined? u['sudo_access'] and u['sudo_access']
        file "/etc/sudoers.d/#{username}" do
            content "#{username}  ALL=(ALL) NOPASSWD: ALL"
            mode "0440"
        end
    end

    # User:password does not work without a missing dependency (ruby-shadow)
    execute "usermod -p x '#{username}'" do
      only_if {! existing_managed_users.member?(username) }
    end

    # Create the cloudscaling group if it does not exist already
    ### TO-DO: Fix creating the cloudscaling user so it has a group.
    group "cloudscaling" do
      gid 30000
      members "cloudscaling"
      action :create
    end

    # Sets ownership of home directory to username:username
    directory ( u['home'] || [ node['users']['dhome'], username ].join('/') ) do
      owner username
      group username
      mode 0755
      action :create
    end

end

'''
 Delete users
'''
deleted_usernames.each do |username|
    log "Destroying user: #{username}"

    # Defined in openssh/definitions/authorized_keys
    authorized_keys username do
        action :delete
    end

    # Defined in users/definitions/destroy_user
    destroy_user username
end




