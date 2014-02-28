execute "chmod-redis-dir" do
  command "chmod -R 755 /var/lib/redis"
end
