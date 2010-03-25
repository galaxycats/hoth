module Hoth
  class ServiceDeployment
    include Singleton

    attr_reader :deployment_modules

    def self.define(&block)
      instance.instance_eval(&block)
    end

    def self.module(module_name)
      instance.deployment_modules[module_name]
    end

    def service_module(module_name, &block)
      deployment_module = DeploymentModule.new(:name => module_name)
      deployment_module.instance_eval(&block)
      @deployment_modules[module_name] = deployment_module
    end

    private

      def initialize
        @deployment_modules = {}
      end
  end
end