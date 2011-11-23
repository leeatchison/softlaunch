require 'yaml'
class SoftLaunch
  attr_reader :id,:name,:usercode
  
  def initialize feature_id
    info=SoftLaunch.config[feature_id.to_s]
    raise SoftLaunch::InvalidFeature if info.nil?
    @id=feature_id
    @name=info["name"]
    @status=info["status"].to_sym
    @usercode=info["usercode"]
  end
 
end
