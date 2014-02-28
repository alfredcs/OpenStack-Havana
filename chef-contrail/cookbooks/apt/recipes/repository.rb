include_recipe "apache2"

%w{default 000-default}.map do |disabled_sites|
  apache_site disabled_sites do
    enable false
  end
end

web_app "apt_repository" do
  docroot node['apt']['repository']['docroot']
  server_name( node['apt']['repository']['server_name'].empty? ? fqdn : node['apt']['repository']['server_name'] )
  cookbook "apt"
end
