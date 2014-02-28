define :destroy_user, :enable => true do
    #include_recipe "users"

    user params[:name] do
        action :nothing
        # Kill is async and might not work immediately.
        retries 5
        notifies :reload, resources(:ohai => 'reload_passwd'), :immediately
    end

    case node[:os]
    when "linux"
        execute "kill-processes #{params[:name]}" do
            command "skill -9 -u #{params[:name]}"
            notifies :remove, resources(:user => params[:name]), :immediately
        end
    else
        # For systems not supported, don't kill processes.
        # Q:Is there a better "nil" resource than this ruby_block hack?
        ruby_block do
            block do
                nil
            end
            notifies :remove, resources(:user => params[:name]), :immediately
        end
    end
end
