name            "heat"

%w{ keystone mysql openstack_config }.each { |c| depends c }
