define :authorized_keys, :keys => [] do
    ruby_block "authorized_keys_#{params[:name]}" do
        block do
            run_context = Chef::RunContext.new(node, {}, Chef::EventDispatch::Dispatcher.new)
            r = Chef::Recipe.new('openssh', 'authorized_keys', run_context)
            username = params[:name]
            key_path = r.openssh_string_format(
                node['openssh']['AuthorizedKeysFile'],
                username
            )

            dir = File.dirname(key_path)
            if not File.directory?(dir)
                d = Chef::Resource::Directory.new(dir, run_context)
                d.mode('0700')
                d.owner(username)
                d.group(node['etc']['passwd'][username]['gid'])
                d.recursive(true)
                d.run_action(params[:action])
            end

            p = Chef::Resource::File.new(key_path, run_context)
            p.mode('0700')
            p.owner(username)
            p.group(node['etc']['passwd'][username]['gid'])
            p.content(params[:keys].to_a.join("\n"))
            p.run_action(params[:action])
        end
    end
end
