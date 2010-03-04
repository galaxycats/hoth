module Hoth
  class DeploymentModule
    attr_accessor :name, :environments

    class Environment
      attr_accessor :endpoint, :deployment_options
      
      def initialize(attributes = {})
        @endpoint           = attributes[:endpoint]
        @deployment_options = attributes[:deployment_options]
      end
    end
    
    def initialize(attributes = {})
      @environments = {}
      @name = attributes[:name]
    end
    
    def env(*options)
      attributes = Hash === options.last ? options.pop : {}
      options.each do |env_name|
        @environments[env_name.to_sym] = Environment.new(attributes)
      end
      self
    end
    
    def [](env_name)
      @environments[env_name.to_sym]
    end
    
    def path(path = nil)
      path.nil? ? @path : @path = path
    end

  end
end