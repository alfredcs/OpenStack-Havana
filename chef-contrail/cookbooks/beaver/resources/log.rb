actions :add, :delete
default_action :add

attribute :name, :kind_of => String, :name_attribute => true
attribute :file, :kind_of => String, :required => true
attribute :tags, :kind_of => Array
attribute :type, :kind_of => String
attribute :exclude, :kind_of => String
