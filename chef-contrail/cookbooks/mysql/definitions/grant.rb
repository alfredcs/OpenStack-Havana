define :grant do

  execute "mysql-install-#{params[:database]}-privileges" do
    #if the database does not exist then apply the permissions - necessary
    #to prevent modifying the non authoritative database:
    command <<-EOS
      echo 'show databases' | \
        mysql -uroot -p#{node['mysql']['server_root_password']} | \
        grep '#{params[:database]}' \
        || /usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} \
             < '/etc/mysql/#{params[:database]}-grants.sql'
    EOS
    action :nothing
  end

  #create the nova db and add permissions for the nova user
  template "/etc/mysql/#{params[:database]}-grants.sql" do
    path "/etc/mysql/#{params[:database]}-grants.sql"
    source "grants-service.sql.erb"
    cookbook "mysql"
    owner "root"
    group "root"
    mode "0600"
    variables(:user => params[:user],
              :password => params[:password],
              :database => params[:database])
    notifies(:run, "execute[mysql-install-#{params[:database]}-privileges]",
             :immediately)
  end
end
