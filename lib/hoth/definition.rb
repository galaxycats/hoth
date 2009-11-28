module Hoth
  class Definition
    def service(service_name, options = {})
      service = ServiceRegistry.add_service(Service.new(service_name, options))
    end
  end
end