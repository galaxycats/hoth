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
      @service_impl_class_name ||= "#{self.name.to_s.camelize}Impl"
      # in Rails development environment we cannot cache the class constant, because it gets unloaded, so you get 
      # an "A copy of xxxImpl has been removed from the module tree but is still active!" error from ActiveSupport dependency mechanism
      # TODO: Try to solve this problem
      # TODO: get rid of these Rails dependencies
      @service_impl_class_name.constantize
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