require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hoth::Definition do
  
  it "should create a Service and add it to the registry instance" do
    service_name = :my_service
    service_options = {
      :params   => [:some_params],
      :returns  => nil,
      :endpoint => :my_service_module
    }

    service = mock("ServiceMock")
    Hoth::Service.should_receive(:new).with(service_name, service_options).and_return(service)
    Hoth::ServiceRegistry.should_receive(:add_service).with(service)
    
    definition = Hoth::Definition.new
    definition.service service_name, service_options
  end
  
end
