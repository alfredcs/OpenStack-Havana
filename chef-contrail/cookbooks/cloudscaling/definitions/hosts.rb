define :host, :action => :add do
  if params[:action] == :add
    bash "add #{params[:name]} to /etc/hosts" do
      code "echo '#{params[:name]} #{params[:ip]}' >> /etc/hosts"
      not_if "grep '^#{params[:name]} #{params[:ip]}$' /etc/hosts"
    end
  end
  if params[:action] == :remove
    bash "remove #{params[:name]} from /etc/hosts" do
      code "sed -i '/^#{params[:name]} #{params[:ip]}$/d'"
      only_if "grep '^#{params[:name]} #{params[:ip]}$' /etc/hosts"
    end
  end
end
