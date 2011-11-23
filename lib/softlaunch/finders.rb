class SoftLaunch
 
  class << self

    def all
      ret=[]
      config.each do |id,data|
        ret<<SoftLaunch.new(id)
      end
      ret
    end
    def find feature
      config.each do |id,data|
        return SoftLaunch.new id if id.to_s==feature.to_s
      end
      return nil
    end
    def find_by_usercode usercode
      config.each do |id,data|
        return SoftLaunch.new id if data["usercode"] and data["usercode"].to_s == usercode.to_s
      end
      return nil
    end
        
  end
  
end
