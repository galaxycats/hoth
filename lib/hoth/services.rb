module Hoth
  class Services
    def self.define(&block)
      ServiceDefinition.new.instance_eval(&block)
    end
    
    class <<self
      attr_writer :env
      
      def env
        @env.to_sym
      end
      
      def method_missing(meth, *args, &blk)
        if _service = ServiceRegistry.locate_service(meth)
          _service.execute(*args)
        else
          super
        end
      end
    end
  end
end