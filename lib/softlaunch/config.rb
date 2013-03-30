class SoftLaunch
  
  class << self
    attr_accessor :cookies, :engine_layout
    
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
      raw_hash = YAML::load(raw_config)
      @config = raw_hash[Rails.env||"none"]
      @config = raw_hash if @config.nil?
    end
    
  end
  
end
