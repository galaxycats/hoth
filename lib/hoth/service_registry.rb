module Hoth
  
  # The ServiceRegistry knows all registered services. You can register new
  # services and locate existing services.
  
  class ServiceRegistry
    include Singleton
    
    # add a service to the registry
    def self.add_service(service)
      instance.add_service(service)
    end
    # alias_method :register_service, :add_service
    
    # find a service with a given name
    def self.locate_service(service_name)
      instance.locate_service(service_name)
    end
    
    def add_service(service) # :nodoc:
      @registry[service.name.to_sym] = service
    end
    
    def locate_service(service_name) # :nodoc:
      @registry[service_name.to_sym]
    end
    
    private
      
      def initialize # :nodoc:
        @registry = {}
      end
  end
end