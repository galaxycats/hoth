require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Transport
    
    describe "WorklingTransport" do
      
      it "should send publish a message via SimplePublisher" do
        endpoint = mock("EndpointMock")
        endpoint.should_receive(:host).and_return("localhost")
        endpoint.should_receive(:port).and_return("22122")
        
        service_module = mock("ServiceModule")
        service_module.should_receive(:name).and_return("TestServiceModule")
        
        service = mock("ServiceMock")
        service.should_receive(:name).and_return("TestService")
        service.should_receive(:endpoint).any_number_of_times.and_return(endpoint)
        service.should_receive(:module).any_number_of_times.and_return(service_module)
        
        SimplePublisher::Topic.should_receive(:new).with(:name => "test_service_module_subscribers__test_service").and_return(topic = mock("Topic"))
        
        SimplePublisher::StarlingConnection.should_receive(:new).with(:host => "localhost", :port => "22122").and_return(connection = mock("Connection"))
        
        SimplePublisher::Publisher.should_receive(:new).with(
          :topic => topic,
          :connection => connection
        ).and_return(publisher = mock("PublisherMock"))

        uid = "GC-123546"
        email_address = "test@example.com"

        publisher.should_receive(:publish).with([uid, email_address])
        
        transport = WorklingTransport.new(service)
        transport.call_remote_with(uid, email_address)
      end
      
      it "should decode params from a message wrapper" do
        params_as_message = ["uid"]
        
        transport = WorklingTransport.new(mock("ServiceMock"))
        transport.decode_params(*params_as_message).should == ["uid"]
      end
      
    end
    
  end
end