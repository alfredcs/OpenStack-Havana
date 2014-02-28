# SMOKETEST DRIVER - v0.0.3

###
###
###
### DO NOT EDIT - GRAB LATEST VERSION FROM SHEEP REPO
###
###
###


#
#                      _        _            _         _      _
#  ___ _ __ ___   ___ | | _____| |_ ___  ___| |_    __| |_ __(_)_   _____ _ __
# / __| '_ ` _ \ / _ \| |/ / _ \ __/ _ \/ __| __|  / _` | '__| \ \ / / _ \ '__|
# \__ \ | | | | | (_) |   <  __/ ||  __/\__ \ |_  | (_| | |  | |\ V /  __/ |
# |___/_| |_| |_|\___/|_|\_\___|\__\___||___/\__|  \__,_|_|  |_| \_/ \___|_|
#
#
#  GOALS:
#   sets up ruby include path
#   sets environment variable SHEEP_DIR
#   requires helper and substratum helper code
#
#  USAGE:
#    require 'smoketest_driver'
#
#    if you don't need the substratum gem loaded, you can do:
#
#      ENV['SMOKETEST_SUBSTRATUM_NOT_NEEDED'] = 'true'
#      require 'smoketest_driver'
#


require 'pp'

# no output buffering
$stdout.sync = true

## include path mucking...
possible_sheep_dirs = []
# case 1: we're in a sheep repo right now - ..
possible_sheep_dirs.push(File.expand_path(File.join(File.dirname(__FILE__), '..')))
# case 2: we're in a jenkins setup with sheep checked out - ../sheep
possible_sheep_dirs.push(File.expand_path('../sheep'))
# case 3: we're in a smoketest directory with sheep two levels up...
possible_sheep_dirs.push(File.expand_path('../../sheep'))
# case 4: sheep is in homedir - ~/sheep
possible_sheep_dirs.push(File.expand_path('~/sheep'))
# case 5: sheep is in some crazy place - $SHEEP_DIR
if ENV['SHEEP_DIR']
	possible_sheep_dirs.push(File.expand_path(ENV['SHEEP_DIR']))
end

# append the library ruby to the sheep paths...
possible_sheep_dirs = possible_sheep_dirs.map{|item| File.join(item, 'library', 'ruby')}

# mess with include path finally
possible_sheep_dirs.each do |dir|
	$LOAD_PATH.push(dir)
end

## test framework setup...
try_count = 0
require 'helpers'
require 'check_for_text_with_timeout'
if ENV['SMOKETEST_SUBSTRATUM_NOT_NEEDED'] == nil
	begin
		try_count = try_count + 1
		require 'substratum_helpers'
	rescue LoadError
		puts "ERROR: it seems like you might not have substratum installed."
		puts "        trying to install substratum (please retry after)..."
		success = bootstrap_substratum()
		#run_command("#{SHEEP_DIR}/sheep blue insheeption inventory setup")
		# TODO: call substratum bootstrap function in helpers...
		if success
			if try_count > 2
				puts "something is messed up... exiting."
				exit 1
			else
				puts "*** substratum successfully installed. continuing..."
				Gem.clear_paths()
				retry
			end
		else
			puts "now raising the exception..."
			raise
		end
	end
end

# export SHEEP_DIR constant...
SHEEP_DIR = ENV['SHEEP_DIR'] || get_sheep_dir_path()