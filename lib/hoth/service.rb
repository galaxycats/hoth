module Hoth
  class Service
    attr_accessor :name, :params_arity, :return_value, :module
    
    def initialize(name, &block)
      @name         = name
      @params_arity = block.arity
      instance_eval(&block)
    end
    
    def returns(return_value)
      @return_value = return_value
    end
    
    def transport
      @transport ||= "hoth/transport/#{endpoint.transport_type}_transport".camelize.constantize.new(self)
    end
    
    def impl_class
      @impl_class_name ||= "#{self.name.to_s.camelize}Impl"
      begin
        @impl_class_name.constantize
      rescue NameError => e
        # no local implementation
        false
      end
    end
    
    def is_local?
      !!impl_class
    end
    
    def execute(*args)
      if self.is_local?
        decoded_params = transport.decode_params(*args)
        result = impl_class.send(:execute, *decoded_params)
        return return_nothing? ? nil : result
      else
        transport.call_remote_with(*args)
      end
    end
    
    def return_nothing?
      return_value == :nothing || return_value == :nil || return_value == nil
    end
    
    def via_endpoint(via = nil)
      @via_endpoint = via || :default
    end
    
    def endpoint
      @endpoint ||= self.module[Hoth.env][@via_endpoint]
    end
  end
end