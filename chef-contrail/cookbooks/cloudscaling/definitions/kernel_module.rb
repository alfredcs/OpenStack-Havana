define :kernel_module, :action => :install do
  if params[:action] == :install
    bash "modprobe #{params[:name]}" do
      code "modprobe #{params[:name]}"
      not_if "lsmod | grep #{params[:name]}"
    end

    bash "install #{params[:name]} in /etc/modules" do
      code "echo '#{params[:name]}' >> /etc/modules"
      not_if "grep '^#{params[:name]}$' /etc/modules"
    end
  end
  if params[:action] == :remove
    bash "rmmod #{params[:name]}" do
      code "rmmod #{params[:name]}"
      only_if "lsmod | grep #{params[:name]}"
    end

    bash "remove #{params[:name]} from /etc/modules" do
      code "sed -i '/^#{params[:name]}$/d'"
      only_if "grep '^#{params[:name]}$' /etc/modules"
    end
  end
end
