class SoftLaunch
  class SoftLaunchController < ApplicationController
    def show
      # render :layout => "soft_launch/application"
      @softlaunch=SoftLaunch.find_by_usercode params[:id]
      render :layout => SoftLaunch.engine_layout
    end
    def update
      @softlaunch=SoftLaunch.find_by_usercode params[:id]
      if params[:sl_enable].to_i!=0
        @softlaunch.enable=true
        flash[:info]="Enabled feature #{@softlaunch.name}"
      else
        @softlaunch.enable=false
        flash[:info]="Disabled feature #{@softlaunch.name}"
      end
      redirect_to soft_launch_path id: @softlaunch.usercode
    end
    
    def soft_launch_controller?
      true
    end
  end
end
