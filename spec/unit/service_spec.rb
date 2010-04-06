require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

class TestServiceImpl
  def self.execute(param1, param2)
  end
end

module Hoth
  
  describe Service do
    
    it "should define parameters and return values" do
      service_block = Proc.new { |param_1, param_2, param_3| returns :some_data }

      service = Service.new("TestService", &service_block)

      service.params_arity.should be(3)
      service.return_nothing?.should be(false)
    end
    
    it "should know its service-impl class" do
      service = Service.new("TestService") {}
      service.impl_class
    end
    
    it "should know that its service-impl class is not available" do
      service = Service.new("TestServiceWithoutImplClass") {}
      service.impl_class.should be(false)
    end
    
    it "should know if it is local or not based on Impl-Class availability" do
      service = Service.new("TestServiceWithoutImplClass") {}
      service.is_local?.should be(false)

      service = Service.new("test_service") {}
      service.is_local?.should be(true)
    end
    
    it "should execute the service stub locally if its impl-class was found" do
      service = Service.new("test_service") { |p1, p2| returns :nothing }
      
      service.should_receive(:is_local?).and_return(true)
      service.impl_class.should_receive(:execute).with(:arg1, :arg2)
      
      service.execute(:arg1, :arg2).should be(nil)
    end
  
    it "should execute the service stub locally if its impl-class was found and return a value" do
      service = Service.new("test_service") { |p1, p2| returns :value }
      
      service.should_receive(:is_local?).and_return(true)
      service.impl_class.should_receive(:execute).with(:arg1, :arg2).and_return(result = mock("ResultMock"))
      
      service.execute(:arg1, :arg2).should be(result)
    end
  
    it "should call the remote service if impl-class does not exist" do
      service = Service.new("test_service_without_impl") { |p1, p2| returns :nothing }
      
      service.should_receive(:is_local?).and_return(false)
      service.should_receive(:transport).and_return(transport = mock("TransportMock"))
      transport.should_receive(:call_remote_with).with(:arg1, :arg2)
      
      service.execute(:arg1, :arg2)    
    end
  
    it "should create transport instance based on endpoint" do
      service = Service.new("test_service") { |p1, p2| returns :nothing }
      service.should_receive(:endpoint).and_return(endpoint = mock("EndpointMock"))
      endpoint.should_receive(:transport).and_return(:http)
      Hoth::Transport.should_receive(:create).with(:http, service)
      service.transport
    end
  
  end
  
end