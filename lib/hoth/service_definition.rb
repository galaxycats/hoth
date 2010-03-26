module Hoth
  class ServiceDefinition
    def service(service_name, &block)
      ServiceRegistry.add_service(Service.new(service_name, &block))
    end
  end
end