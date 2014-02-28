package "monit"

cookbook_file "/etc/default/monit" do
    source "monit.default"
    owner "root"
    group "root"
    mode 0644
end

cookbook_file "/etc/init.d/monit" do
    source 'init-monit.sh'
    owner 'root'
    group 'root'
    mode 0755
end

service "monit" do
    action [:enable, :start]
    supports [:start, :restart, :stop]
end

directory "/etc/monit/conf.d/" do
    owner  'root'
    group 'root'
    mode 0755
    action :create
    recursive true
end

template "/etc/monit/monitrc" do
    owner "root"
    group "root"
    mode 0700
    source 'monitrc.erb'
    notifies :restart, 'service[monit]', :delayed
end
