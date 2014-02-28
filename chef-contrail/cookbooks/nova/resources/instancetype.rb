actions :update, :delete, :purge, :create
default_action :update

attribute :flavor, :kind_of => [Integer, String], :required=> true
attribute :swap, :kind_of => [Integer, String], :default => 0
attribute :root_gb, :kind_of => [Integer, String], :default => 0
attribute :ephemeral_gb, :kind_of => [Integer, String], :default => 0
attribute :memory, :kind_of => [Integer, String], :default => 0
attribute :cpu, :kind_of => [Integer, String], :default => 1

attr_accessor :exists
