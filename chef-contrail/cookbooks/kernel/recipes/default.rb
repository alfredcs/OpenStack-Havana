file "/etc/modprobe.d/blacklist-custom.conf" do
  action :delete
end
if node['kernel']['blacklistmodules'].first != ""

template "/etc/modprobe.d/blacklist-custom.conf" do
  mode "0600"
  owner "root"
  group "root"
  source "blacklist-custom.erb"
end

template "/tmp/unloadmodules.sh" do
  mode "0700"
  owner "root"
  group "root"
  source "unloadmodules.erb"
end

execute "unloadmodules" do
  command "/tmp/unloadmodules.sh" 
  returns [0,1] 
    action :run
end

end
