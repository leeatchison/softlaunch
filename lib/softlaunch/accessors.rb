require 'yaml'
class SoftLaunch
  
  def launched?
    return true if @status==:enabled
    return false if @status==:disabled
    return false if !user_specific?
    return cookie_enabled?
  end
  
  def enabled?
    @status==:enabled
  end
  
  def disabled?
    @status==:disabled
  end
  
  def user_specific?
    @status==:user
  end
  
  def status_string
    case @status
    when :disabled then "Disabled"
    when :enabled then "Enabled"
    when :user then "Per User"
    else
      "???#{@status}???"
    end
  end
  
end
