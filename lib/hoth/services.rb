module Hoth
  class Services
    def self.define(&block)
      Definition.new.instance_eval(&block)
    end
    
    def self.env
      (ENV["RAILS_ENV"] || 'test').to_sym
    end
    
    class <<self
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