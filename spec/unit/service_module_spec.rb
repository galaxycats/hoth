require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hoth::ServiceModule do
  
  it "should have a name" do
    service_module = Hoth::ServiceModule.new :name => :my_service_module
    service_module.name.should equal(:my_service_module)
  end
  
  it "should have an environment" do
    service_module = Hoth::ServiceModule.new(:name => "service_module_name")
    block = Proc.new {}
    service_module.env :test, &block
    service_module[:test].should be_a(Hoth::ServiceModule::Environment)
  end
  
  describe Hoth::ServiceModule::Environment do

    it "should have an endpoint" do
      endpoint_mock = mock("Hoth::Endpoint", :null_object => true)
      
      endpoint_block = Proc.new { endpoint :development, {} }
      env = Hoth::ServiceModule::Environment.new(&endpoint_block)      
      env[:development].should_not be(nil)
    end
    
  end
  
end