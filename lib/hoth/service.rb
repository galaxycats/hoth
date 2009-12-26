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
      transport = "hoth/transport/#{endpoint.transport_type}_transport".camelize.constantize.new(self)
      
      if self.endpoint.is_local?
        decoded_params = transport.decode_params(*args)
        Hoth::Logger.debug "decoded_params: #{decoded_params.inspect}"
        result = "#{self.name.to_s.camelize}Impl".constantize.send(:execute, *decoded_params)
        return return_value ? result : nil
      else
        transport.call_remote_with(*args)
      end
    end
  end
end