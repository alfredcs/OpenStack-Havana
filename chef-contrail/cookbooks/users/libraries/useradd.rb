class Chef
    class Provider
        class User
            class UseraddMinUID < Chef::Provider::User::Useradd
                def useradd_options
                    opts = super
                    opts << " -K UID_MIN=#{node['users']['table_first_uid']}"
                    opts
                end
            end
        end
    end
end
