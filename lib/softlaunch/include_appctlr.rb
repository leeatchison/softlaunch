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

end
