module Users
  def non_system_users
    node[:etc][:passwd].to_hash.reject {|k,v|
      v['uid'].to_i < [node[:users][:first_uid].to_i,
                       node[:users][:table_first_uid].to_i].min ||
      v['uid'].to_i > [node[:users][:last_uid].to_i,
                       node[:users][:table_last_uid].to_i].max
    }
  end

  def non_managed_users
    node[:etc][:passwd].to_hash.reject {|k,v|
      v['uid'].to_i < node[:users][:first_uid].to_i ||
      v['uid'].to_i > node[:users][:last_uid].to_i
    }
  end

  def managed_users
    node[:etc][:passwd].to_hash.reject {|k,v|
      v['uid'].to_i < node['users']['table_first_uid'].to_i ||
      v['uid'].to_i > node['users']['table_last_uid'].to_i
    }
  end
end

class Chef
  class Recipe
    include Users
  end

  class Resource
    include Users
  end
end
