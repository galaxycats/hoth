require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hoth::DeploymentModule do
  
  it "should have a name" do
    deployment_module = Hoth::DeploymentModule.new :name => :my_service_module
    deployment_module.name.should equal(:my_service_module)
  end
  
  it "should have an environment" do
    deployment_module = Hoth::DeploymentModule.new
    
    env_specific_options = {}
    env_mock = mock("Hoth::DeploymentModule::Environment", :null_object => true)
    
    Hoth::DeploymentModule::Environment.should_receive(:new).with(env_specific_options).and_return(env_mock)
    
    deployment_module.env :test, env_specific_options
    deployment_module[:test].should equal(env_mock)
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
  end
  
end