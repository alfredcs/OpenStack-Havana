########################################################################
# Toggles - These can be overridden at the environment level
########################################################################

default["ceilometer"]["agent_enabled"] = false

default['ceilometer']['app_ip'] = OCS.app_ip(node)
default['ceilometer']['api_port'] = 8777

# DB/mysql/mongodb fields are only for the backend servers.
default["ceilometer"]["db"]["scheme"] = 'mysql'

# These settings might do if we used mysql instead of monogo
default["ceilometer"]["mysql"]["host"] = OCS.mysql_ip
default["ceilometer"]["mysql"]["database"] = 'ceilometer'
default["ceilometer"]["mysql"]["port"] = 3306
default["ceilometer"]["mysql"]["user"] = 'ceilometer'
default["ceilometer"]["mysql"]["password"] = nil

# Ceilometer could use mongodb, configuration might look like this:
default["ceilometer"]["db"]["monogodb"]["host"] = nil
default["ceilometer"]["db"]["monogodb"]["database"] = 'ceilometer'
default["ceilometer"]["db"]["monogodb"]["port"] = 27017
default["ceilometer"]["db"]["monogodb"]["username"] = 'ceilometer'
default["ceilometer"]["db"]["monogodb"]["password"] = nil


default["ceilometer"]["dependent_pkgs"] = ['libxslt-dev', 'libxml2-dev', 'python-ceilometerclient']
default["ceilometer"]["periodic_interval"] = 60

default['ceilometer']['keystone']['service_user'] = 'ceilometer'
default['ceilometer']['user'] = 'ceilometer'
default['ceilometer']['group'] = 'ceilometer'
default['ceilometer']['metering_secret'] = 'changeme'
