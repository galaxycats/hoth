module Hoth
  class Modules
    include Singleton

    attr_reader :service_modules

    def self.define(&block)
      instance.instance_eval(&block)
    end

    def self.module(module_name)
      instance.service_modules[module_name]
    end
    
    def service_module(module_name, &block)
      service_module = ServiceModule.new(:name => module_name)
      service_module.instance_eval(&block)
      @service_modules[module_name] = service_module
    end
    
    private

      def initialize
        @service_modules = {}
      end
  end
end