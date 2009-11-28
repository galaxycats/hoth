module Hoth
  class Service
    attr_accessor :name, :endpoint, :params, :return_value
    
    def initialize(name, args = {})
      @name         = name
      @endpoint     = ServiceDeployment.module(args[:endpoint])[Services.env].endpoint
      @params       = args[:params]
      @return_value = args[:returns]
    end
    
    def execute(*args)
      if self.endpoint.is_local?
        result = "#{self.name.to_s.camelize}Impl".constantize.send(:execute, *args)
        return return_value ? result : nil
      else
        transport = "hoth/transport/#{endpoint.transport_type}_transport".camelize.constantize.new(self)
        transport.call_remote_with(*args)
      end
    end
  end
end