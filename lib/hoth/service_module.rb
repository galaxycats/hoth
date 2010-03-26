module Hoth
  class ServiceModule
    attr_accessor :name, :environments

    class Environment
      attr_accessor :endpoints
      
      def initialize(&block)
        @endpoints = {}
        instance_eval(&block)
      end
      
      def endpoint(endpoint_name, options)
        @endpoints[endpoint_name.to_sym] = Endpoint.new(options)
      end
      
      def [](endpoint_name)
        @endpoints[endpoint_name.to_sym]
      end
    end
    
    def initialize(attributes = {})
      @environments = {}
      @name = attributes[:name]
    end
    
    def env(env_name, &block)
      @environments[env_name.to_sym] = Environment.new(&block)
      self
    end
    
    def add_service(service_name, options = {})
      unless self.environments[ServiceDeployment.env]
        puts("no endpoint-definition for environment '#{ServiceDeployment.env}' and service '#{service_name}'")
        exit
      end

      service = ServiceRegistry.locate_service(service_name.to_sym)

      unless service
        puts("tried to add service '#{service_name}' but was not defined by service-definition")
        exit
      end
      
      service.endpoint = self.environments[ServiceDeployment.env][options[:via] || :default]
    end
    
    def [](env_name)
      @environments[env_name.to_sym]
    end

  end
end