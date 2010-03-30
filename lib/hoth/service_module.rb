module Hoth
  class ServiceModule
    attr_accessor :name, :environments

    class Environment
      attr_accessor :endpoints
      
      def initialize(&block)
        @endpoints = {}
        instance_eval(&block)
      end
      
      def endpoint(endpoint_name, &block)
        @endpoints[endpoint_name.to_sym] = Endpoint.new(&block)
      end
      
      def [](endpoint_name)
        @endpoints[endpoint_name.to_sym]
      end
    end
    
    def initialize(attributes = {})
      @environments = {}
      @name = attributes[:name]
    end
    
    def env(*env_names, &block)
      env_names.each do |env_name|
        @environments[env_name.to_sym] = Environment.new(&block)
      end
    end
    
    def add_service(service_name, options = {})
      unless self.environments[Hoth.env]
        puts("no endpoint-definition for environment '#{Hoth.env}' and service '#{service_name}'")
        exit
      end

      service = ServiceRegistry.locate_service(service_name.to_sym)

      unless service
        puts("tried to add service '#{service_name}' but was not defined by service-definition")
        exit
      end
      
      service.module = self
      service.via_endpoint(options[:via])
    end
    
    def [](env_name)
      @environments[env_name.to_sym]
    end

  end
end