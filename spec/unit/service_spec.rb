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
      service.return_value.should be(:some_data)
    end
    
    it "should know its service-impl class" do
      service = Service.new("TestService") {}
      service.impl_class
    end
    
    it "should know that its service-impl class is not available" do
      service = Service.new("TestServiceWithoutImplClass") {}
      service.impl_class
    end
    
    it "should execute the service stub locally if its impl-class was found" do
      service = Service.new("test_service") { |p1, p2| returns :nothing }
      
      service.should_receive(:transport).and_return(transport = mock("TransportMock"))
      transport.should_receive(:decode_params).with(:arg1, :arg2).and_return(decoded_params = mock("DecodedParamsMock"))
      service.impl_class.should_receive(:execute).with(decoded_params)
      
      service.execute(:arg1, :arg2)
    end
  
    it "should call the remote service if impl-class does not exist" do
      service = Service.new("test_service_without_impl") { |p1, p2| returns :nothing }
      
      service.should_receive(:transport).and_return(transport = mock("TransportMock"))
      transport.should_receive(:call_remote_with).with(:arg1, :arg2)
      
      service.execute(:arg1, :arg2)    
    end
  
    it "should create transport instance based on endpoint" do
      service = Service.new("test_service") { |p1, p2| returns :nothing }
      service.should_receive(:endpoint).and_return(endpoint = mock("EndpointMock"))
      endpoint.should_receive(:transport_type).and_return(:http)
      Hoth::Transport::HttpTransport.should_receive(:new).with(service)
      service.transport
    end
  
  end
  
end