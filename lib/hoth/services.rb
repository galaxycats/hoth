module Hoth
  class Services
    
    # With Hoth::Services.define followed by a block you define all your
    # available services.
    #
    # Example:
    #
    #     Hoth::Services.define do
    #       
    #       service :increment_counter do |counter|
    #         returns :nothing
    #       end
    #       
    #       service :value_of_counter do |counter|
    #         returns :fixnum
    #       end
    #       
    #       service :create_account do |account|
    #         returns :account_id
    #       end
    #       
    #     end
    #   
    # after defining your services you can call each of them with
    # <tt>Hoth::Services.service_name(params)</tt>
    #       
    #     Hoth::Services.increment_counter(counter)
    #     current_number = Hoth::Services.value_of_counter(counter)
    #     created_account = Hoth::Services.create_account(account)
    #
    # see Hoth::ServiceDefinition for further informations of the block
    # content.
    
    def self.define(&block)
      ServiceDefinition.new.instance_eval(&block)
    end
    
    class <<self

      # this is where the services get called
      def method_missing(meth, *args, &blk) # :nodoc:
        if _service = ServiceRegistry.locate_service(meth)
          _service.execute(*args)
        else
          super
        end
      end
    end
  end
end