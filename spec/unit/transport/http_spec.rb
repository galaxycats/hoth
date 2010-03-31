require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Transport
    describe Http do
      
      before(:each) do
        @service_mock = mock("ServiceMock")
      end
      
      it "should call a remote via http" do
        @service_mock.should_receive(:return_nothing?).and_return(false)
        
        params = {:first_name => "Seras", :last_name => "Victoria"}

        transport = Http.new(@service_mock)
        transport.should_receive(:post_payload).with([params])
        transport.call_remote_with(params)
      end
      
      it "should post payload encoded with JSON" do
        @service_mock.should_receive(:endpoint).and_return(endpoint = mock("EndpointMock"))
        @service_mock.should_receive(:name).and_return("service_name")
        endpoint.should_receive(:to_url).and_return("http://localhost:3000/execute")
        
        URI.should_receive(:parse).with("http://localhost:3000/execute").and_return(uri = mock("URIMock"))
        Net::HTTP.should_receive(:post_form).with(uri, {"name" => "service_name", "params" => "params".to_json})
        
        transport = Http.new(@service_mock)
        transport.post_payload("params")
      end
      
      it "should handle " do
        
      end
    end
  end
end
