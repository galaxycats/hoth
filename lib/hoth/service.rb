module Hoth
  class Service
    attr_accessor :name, :params_arity, :module
    
    def initialize(name, &block)
      @name         = name
      @params_arity = block.arity
      instance_eval(&block)
    end
    
    def returns(return_value)
      @return_value = return_value
    end
    
    def transport
      @transport ||= Transport.create(endpoint.transport, self)
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
      result = self.is_local? ? impl_class.send(:execute, *args) : transport.call_remote_with(*args)
      return return_nothing? ? nil : result
    end
    
    def return_nothing?
      [:nothing, :nil, nil].include? @return_value
    end
    
    def via_endpoint(via = nil)
      @via_endpoint = via || :default
    end
    
    def endpoint
      @endpoint ||= self.module[Hoth.env][@via_endpoint]
    end
  end
end
