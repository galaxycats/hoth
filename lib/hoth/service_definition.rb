module Hoth
  class ServiceDefinition
    
    # create a new service with service_name and register it at the
    # ServiceRegistry. The paramters of the block define the parameters of the
    # defined service. Within the block you can describe the return value.
    #
    # Example:
    #
    #     service :create_account do |account|
    #       returns :account_id
    #     end
    #
    def service(service_name, &block)
      ServiceRegistry.add_service(Service.new(service_name, &block))
    end
  end
end