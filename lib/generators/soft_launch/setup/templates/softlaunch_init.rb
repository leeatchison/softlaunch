#
#
# SoftLaunch Configuration
#
#

#
# Specify the location of the configuraiton file.
# Default: RAILS_ROOT/config/softlaunch.yml
#
SoftLaunch.config_file=Rails.root.join "config/softlaunch.yml"

#
# Specify a layout file to use for the softlaunch feature page.
# NOTE: If you specify a layout file for the engine, then in this layout file, all
# URL helpers must be prefixed with "main_app". So, for instance, you can't use
# "root_path", you must use "main_app.root_path". If you do not do this, you will
# get errors when rendering a page from the engine. Specify 'nil' will not use any
# template file.
# This is due to how engines handle namespaced applications.
#
SoftLaunch.engine_layout=nil # Do not use any layout file.
# SoftLaunch.engine_layout="application" # Use the global application layout file.
