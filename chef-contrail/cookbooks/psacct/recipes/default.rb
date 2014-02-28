package "acct" do
  action :install
end

service "acct" do
  service_name 'acct'
  action [:enable, :start]
end

