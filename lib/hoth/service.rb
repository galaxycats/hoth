module Hoth
  class Service
    attr_accessor :name, :endpoint, :params, :return_value
    
    def initialize(name, args = {})
      @name         = name
      @endpoint     = ServiceDeployment.module(args[:endpoint])[Services.env].endpoint
      @params       = args[:params]
      @return_value = args[:returns]
    end
    
    def transport
      @transport ||= "hoth/transport/#{endpoint.transport_type}_transport".camelize.constantize.new(self)
    end
    
    def service_impl_class
      @service_impl_class ||= "#{self.name.to_s.camelize}Impl".constantize
    end
    
    def execute(*args)
      if self.endpoint.is_local?
        decoded_params = transport.decode_params(*args)
        Hoth::Logger.debug "decoded_params: #{decoded_params.inspect}"
        result = service_impl_class.send(:execute, *decoded_params)
        return return_value ? result : nil
      else
        transport.call_remote_with(*args)
      end
    end
  end
end