require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hoth::DeploymentModule do
  
  it "should have a name" do
    deployment_module = Hoth::DeploymentModule.new :name => :my_service_module
    deployment_module.name.should equal(:my_service_module)
  end
  
  it "should have an environment" do
    deployment_module = Hoth::DeploymentModule.new(:name => "deployment_module_name")
    
    env_specific_options = {:endpoint => endpoint = mock("EndpointMock"), :deployment_options => "deployment_options"}
    endpoint.should_receive(:module_name=).with("deployment_module_name").exactly(3).times
    deployment_module.env :test, env_specific_options
    deployment_module[:test].should be_a(Hoth::DeploymentModule::Environment)

    deployment_module.env :staging, :production, env_specific_options
    deployment_module[:staging].should be_a(Hoth::DeploymentModule::Environment)
    deployment_module[:production].should be_a(Hoth::DeploymentModule::Environment)
    
    [:test, :staging, :production].each do |environment|
      deployment_module[environment].endpoint.should == endpoint
      deployment_module[environment].deployment_options.should == "deployment_options"
    end
  end
  
  it "should have a path pointing to the service root" do
    deployment_module = Hoth::DeploymentModule.new
    deployment_module.path "services_dir/my_service"
    deployment_module.path.should == "services_dir/my_service"
  end

  describe Hoth::DeploymentModule::Environment do
    it "should have an endpoint" do
      endpoint_mock = mock("Hoth::Endpoint", :null_object => true)
      
      env = Hoth::DeploymentModule::Environment.new(:endpoint => endpoint_mock)
      env.endpoint.should equal(endpoint_mock)
    end

    it "should have deployment options" do
      some_options = {:server_instances => 5}
      
      env = Hoth::DeploymentModule::Environment.new(:deployment_options => some_options)
      env.deployment_options.should equal(some_options)
    end
    
    it "should set propagate the module_name of the enclosing DeploymentModule to its endpoint" do
      endpoint = mock("Hoth::Endpoint", :null_object => true)
      endpoint.should_receive(:module_name=).with("deployment_module_name")
      
      env = Hoth::DeploymentModule::Environment.new(:endpoint => endpoint)
      env.propagate_module_name_to_endpoint("deployment_module_name")
    end
  end
  
end