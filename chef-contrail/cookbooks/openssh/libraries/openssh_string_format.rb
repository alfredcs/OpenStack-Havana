class Chef
    class Recipe
        def openssh_string_format(str, username)
            return str.split('%%').map {|substring|
                substring.gsub(
                    /%h/, node['etc']['passwd'][username]['dir']
                ).gsub(
                    /%u/, username
                )
            }.join('%')
        end
    end
end
