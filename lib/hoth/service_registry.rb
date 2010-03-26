module Hoth
  class ServiceRegistry
    include Singleton
    
    def self.add_service(service)
      instance.add_service(service)
    end
    
    def self.locate_service(service_name)
      instance.locate_service(service_name)
    end
    
    def add_service(service)
      @registry[service.name.to_sym] = service
    end
    
    def locate_service(service_name)
      @registry[service_name.to_sym]
    end
    
    private
    
      def initialize
        @registry = {}
      end
  end
end