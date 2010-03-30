require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

module Hoth
  
  describe ServiceModule do
  
    it "should have a name" do
      service_module = ServiceModule.new :name => :my_service_module
      service_module.name.should equal(:my_service_module)
    end
  
    it "should have an environment" do
      service_module = ServiceModule.new(:name => "service_module_name")
      block = Proc.new {}
      service_module.env :test, &block
      service_module[:test].should be_a(ServiceModule::Environment)
    end
  
    it "should have multiple environments" do
      service_module = ServiceModule.new(:name => "service_module_name")
      block = Proc.new {}
      service_module.env :test, :development, &block
      service_module[:test].should be_a(ServiceModule::Environment)
      service_module[:development].should be_a(ServiceModule::Environment)
    end
  
    it "should be able to add services" do
      service_module = ServiceModule.new(:name => "service_module_name")
      block = Proc.new {}
      
      service_module.env :test, &block
      
      ServiceRegistry.should_receive(:locate_service).with(:service_name).and_return(service = mock("ServiceMock"))
      service.should_receive(:module=).with(service_module)
      service.should_receive(:via_endpoint).with(:special_endpoint)
      
      service_module.add_service("service_name", :via => :special_endpoint)
    end
  
    describe ServiceModule::Environment do

      it "should have an endpoint" do
        endpoint_mock = mock("Endpoint", :null_object => true)
      
        endpoint_block = Proc.new do
          endpoint :development do
            host 'localhost'
          end
        end
        
        env = ServiceModule::Environment.new(&endpoint_block)      
        env[:development].should_not be(nil)
      end
    
    end
  
  end
  
end