actions :add, :delete
default_action :add

attribute :name, :kind_of => String, :name_attribute => true
attribute :bind, :kind_of => String, :default => '127.0.0.1'
attribute :join, :kind_of => Array
attribute :port_offset, :kind_of => Integer, :required => true
