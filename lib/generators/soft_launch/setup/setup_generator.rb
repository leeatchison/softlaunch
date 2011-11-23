class SoftLaunch
  class SetupGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    def create_initializer
      copy_file "softlaunch_init.rb", "config/initializers/softlaunch_init.rb"
      copy_file "softlaunch.yml", "config/softlaunch.yml"
      route "mount SoftLaunch::Engine => \"/softlaunch\""
    end
  end
end
