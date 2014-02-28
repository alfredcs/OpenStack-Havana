actions :enable, :start, :monitor
default_action :start

attribute :template_source, :kind_of => [String], :required => true
