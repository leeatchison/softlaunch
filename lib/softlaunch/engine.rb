class SoftLaunch
  if defined? Rails
    class Engine < Rails::Engine
      engine_name "soft_launch"
      isolate_namespace SoftLaunch
      initializer 'soft_launch.controller' do |app|
        ActiveSupport.on_load(:action_controller) do
          include SoftLaunchApplicationController
          helper_method :launched?
          helper_method :softlaunch
          before_filter :setup_soft_launch
        end
      end
    end
  end
end
