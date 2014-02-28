include_recipe "ubuntu"
package "apt-cacher-ng"


template "/etc/apt-cacher-ng/acng.conf" do
  owner "apt-cacher-ng"
  group "apt-cacher-ng"
end


service 'apt-cacher-ng' do
  action [ :start, :enable ]
  supports :start => true, :restart => true, :stop => true
  subscribes :restart, 'template[/etc/apt-cacher-ng/acng.conf]'
end


node['apt_cacher_ng']['mirrors'].each do |mirror_name,mirror_url|
  file "/usr/lib/apt-cacher-ng/#{mirror_name}_mirrors" do
    content mirror_url
    notifies :restart, 'service[apt-cacher-ng]'
  end

  link "/etc/apt-cacher-ng/#{mirror_name}_mirrors" do
    to "/usr/lib/apt-cacher-ng/#{mirror_name}_mirrors"
  end
end


bash "import local debs into apt-cacher-ng" do
  action :nothing
  code <<-EOF
    test -x /var/cache/apt-cacher-ng/_import || sudo mkdir -p -m 2755 /var/cache/apt-cacher-ng/_import
    cp /var/cache/apt/archives/*.deb /var/cache/apt-cacher-ng/_import/.
    sudo chown -R apt-cacher-ng.apt-cacher-ng /var/cache/apt-cacher-ng/_import
    curl http://localhost:3142/acng-report.html?doImport=Start+Import#bottom
    sudo apt-get update
  EOF
  subscribes :run, 'package[apt-cacher-ng]', :delayed
end


