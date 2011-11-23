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
  
  def launched?
    return true if @status==:enabled
    return false if @status==:disabled
    return false if !user_specific?
    raise SoftLaunch::CookiesNotConfigured if SoftLaunch.cookies.nil?
    # User Status...(force true and false, even if 1, 0, nil, etc.)
    return true if SoftLaunch.cookies[cookie_name]
    return false
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
  
  def enable= status
    if status
      SoftLaunch.cookies[cookie_name]=true
    else
      SoftLaunch.cookies.delete cookie_name
    end
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
  
  class << self
    attr_accessor :cookies, :engine_layout
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
    
    
    
    def reset
      @config_file=nil
      @config=nil
    end
    def config_file= config_file # Where is the config file located?
      raise FileAlreadyInUse if @config
      @config_file=config_file
    end
    def config_file
      @config_file||=Rails.root.join "config/softlaunch.yml"
    end
    def config
      return @config if @config
      raw_config = File.read(config_file)
      if raw_config.nil?
        puts "No configuration file provided"
        logger.error "No configuration file provided"
        raise InvalidConfiguration
      end
      @config = YAML::load(raw_config)[ENV["RAILS_ENV"]||"development"]
      @config
    end
    
    class FileAlreadyInUse<Exception;end
    class InvalidFeature<Exception;end
    class InvalidConfiguration<Exception;end
    class CookiesNotConfigured<Exception;end
  end
  
  private
  def cookie_name
    "soft_launch_#{id}".to_sym
  end
  
end
