name            "cinder"

%w{ keystone mysql openstack_config }.each { |c| depends c }
