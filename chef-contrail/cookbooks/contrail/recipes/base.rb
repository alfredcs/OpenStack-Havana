directory node['contrail']['config_dir']
directory node['contrail']['log_dir']

execute "ldconfig-contrail" do
  command "ldconfig"
  action :nothing
end

file '/etc/ld.so.conf.d/contrail.conf' do
  content '/usr/lib64/contrail/'
  mode 0644
  notifies :run, 'execute[ldconfig-contrail]'
end
