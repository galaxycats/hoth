module Hoth
  class ServiceModule

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
    
    attr_accessor :name, :environments, :registered_services

    def initialize(attributes = {})
      @environments = {}
      @registered_services = []
      @name = attributes[:name]
    end
    
    def env(*env_names, &block)
      env_names.each do |env_name|
        @environments[env_name.to_sym] = Environment.new(&block)
      end
    end
    
    def add_service(service_name, options = {})
      raise HothException.new("no endpoint-definition for environment '#{Hoth.env}' and service '#{service_name}'") unless self.environments[Hoth.env]

      service = ServiceRegistry.locate_service(service_name.to_sym)

      raise HothException.new("tried to add service '#{service_name}' but was not defined by service-definition") unless service
      
      service.module = self
      service.via_endpoint(options[:via])

      @registered_services << service
    end
    
    def [](env_name)
      @environments[env_name.to_sym]
    end

  end
end
