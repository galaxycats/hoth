require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

module Hoth
  describe ServiceDefinition do
  
    it "should create a Service and add it to the registry instance" do
      service_name = :my_service
      
      definition = ServiceDefinition.new
      definition.service service_name do |some_params|
        returns :nothing
      end
      
      service = ServiceRegistry.locate_service(service_name)
      service.should_not be(nil)
      service.params_arity.should be(1)
      service.return_value.should be(:nothing)
    end
  
  end
end