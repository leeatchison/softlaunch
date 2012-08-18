module SoftLaunchApplicationController

  def launched? ident
    sl=SoftLaunch.find ident
    return false if sl.nil?
    sl.launched?
  end

  def softlaunch ident
    launched? ident
  end

  def setup_soft_launch
    SoftLaunch.cookies=cookies
  end

  module ClassMethods
    def check_softlaunched ident,opts={}
      raise "Invalid softlaunch identifier (#{self.name}::check_softlaunched: ident: #{ident.inspect})" unless ident.kind_of?(Symbol)
      before_filter(opts) do |c|
        sl=SoftLaunch.find ident
        unless sl and sl.launched?
          flash[:error]="That page is not available."
          redirect_to root_path
        end
      end
    end
  end
  def self.included(base)
    base.extend ClassMethods
  end
end
