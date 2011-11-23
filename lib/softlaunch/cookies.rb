class SoftLaunch
  
  def enable= status
    if status
      SoftLaunch.cookies[cookie_name]=true
    else
      SoftLaunch.cookies.delete cookie_name
    end
  end
  
  private
  
  def cookie_enabled?
    raise SoftLaunch::CookiesNotConfigured if SoftLaunch.cookies.nil?
    # User Status...(force true and false, even if 1, 0, nil, etc.)
    return true if SoftLaunch.cookies[cookie_name]
    return false
  end

  def cookie_name
    "soft_launch_#{id}".to_sym
  end
  
end
