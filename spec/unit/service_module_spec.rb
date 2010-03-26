require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hoth::ServiceModule do
  
  it "should have a name" do
    service_module = Hoth::ServiceModule.new :name => :my_service_module
    service_module.name.should equal(:my_service_module)
  end
  
  it "should have an environment" do
    service_module = Hoth::ServiceModule.new(:name => "service_module_name")
    
    env_specific_options = {:endpoint => endpoint = mock("EndpointMock"), :deployment_options => "deployment_options"}
    endpoint.should_receive(:module_name=).with("service_module_name").exactly(3).times
    service_module.env :test, env_specific_options
    service_module[:test].should be_a(Hoth::ServiceModule::Environment)

    service_module.env :staging, :production, env_specific_options
    service_module[:staging].should be_a(Hoth::ServiceModule::Environment)
    service_module[:production].should be_a(Hoth::ServiceModule::Environment)
    
    [:test, :staging, :production].each do |environment|
      service_module[environment].endpoint.should == endpoint
      service_module[environment].deployment_options.should == "deployment_options"
    end
  end
  
  it "should have a path pointing to the service root" do
    service_module = Hoth::ServiceModule.new
    service_module.path "services_dir/my_service"
    service_module.path.should == "services_dir/my_service"
  end

  describe Hoth::ServiceModule::Environment do
    it "should have an endpoint" do
      endpoint_mock = mock("Hoth::Endpoint", :null_object => true)
      
      env = Hoth::ServiceModule::Environment.new(:endpoint => endpoint_mock)
      env.endpoint.should equal(endpoint_mock)
    end

    it "should have deployment options" do
      some_options = {:server_instances => 5}
      
      env = Hoth::ServiceModule::Environment.new(:deployment_options => some_options)
      env.deployment_options.should equal(some_options)
    end
    
    it "should set propagate the module_name of the enclosing ServiceModule to its endpoint" do
      endpoint = mock("Hoth::Endpoint", :null_object => true)
      endpoint.should_receive(:module_name=).with("service_module_name")
      
      env = Hoth::ServiceModule::Environment.new(:endpoint => endpoint)
      env.propagate_module_name_to_endpoint("service_module_name")
    end
  end
  
end