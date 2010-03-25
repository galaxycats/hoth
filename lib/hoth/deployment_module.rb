module Hoth
  class DeploymentModule
    attr_accessor :name, :environments

    class Environment
      attr_accessor :endpoint, :deployment_options
      
      def initialize(attributes = {})
        @endpoint           = attributes[:endpoint]
        @deployment_options = attributes[:deployment_options]
      end
      
      def propagate_module_name_to_endpoint(module_name)
        @endpoint.module_name = module_name
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
        @environments[env_name.to_sym].propagate_module_name_to_endpoint(@name)
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