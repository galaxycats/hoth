require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Transport
    
    describe "WorklingTransport" do
      
      it "should send publish a message via SimplePublisher" do
        endpoint = mock("EndpointMock")
        endpoint.should_receive(:module_name).and_return("TestServiceModule")
        endpoint.should_receive(:host).and_return("localhost")
        endpoint.should_receive(:port).and_return("22122")
        
        service = mock("ServiceMock")
        service.should_receive(:name).and_return("TestService")
        service.should_receive(:endpoint).any_number_of_times.and_return(endpoint)
        
        SimplePublisher::Topic.should_receive(:new).with("test_service_module_subscriber__test_service").and_return(topic = mock("Topic"))
        
        SimplePublisher::StarlingConnection.should_receive(:new).with(:host => "localhost", :port => "22122").and_return(connection = mock("Connection"))
        
        SimplePublisher::Publisher.should_receive(:new).with(
          :topic => topic,
          :connection => connection
        ).and_return(publisher = mock("PublisherMock"))

        args = [{:uid => "GC-123546"}]

        publisher.should_receive(:publish).with(*args)
        
        transport = WorklingTransport.new(service)
        transport.call_remote_with(*args)
      end
      
    end
    
  end
end