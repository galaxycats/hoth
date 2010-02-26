module Hoth
  class DeploymentModule
    attr_accessor :name

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
    
    def env(env_name, options)
      @environments[env_name] = Environment.new(options)
    end
    
    def [](env_name)
      @environments[env_name]
    end
    
    def path(path = nil)
      path.nil? ? @path : @path = path
    end

  end
end