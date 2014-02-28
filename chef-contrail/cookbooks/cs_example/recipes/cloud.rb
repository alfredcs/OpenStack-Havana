# Create an example cloud using our cloud provider
# uses the attribute default for cloud name.
cloud node['cs_example']['cloud']['name'] do
  action :rain
end
