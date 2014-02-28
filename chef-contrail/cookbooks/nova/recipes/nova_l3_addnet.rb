include_recipe "nova::tools"

execute "run l3 addnet" do
  command "cd /home/nova/tools; bash l3setup"
end
