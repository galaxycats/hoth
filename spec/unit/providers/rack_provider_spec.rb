require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

require File.expand_path(File.join(File.dirname(__FILE__), '../../../',  'lib', 'hoth', 'providers', 'rack_provider'))

require 'rack/mock'

module Hoth
  module Providers
    
    describe RackProvider do
      
      it "should get transport and encoder based on called service" do
        app = stub("ApplicationStub").as_null_object
        middleware = Hoth::Providers::RackProvider.new(app)
        
        encoder = mock("EncoderMock")
        encoder.should_receive(:decode).with("some_parameter").and_return(decoded_params = "some_parameter_decoded")
        encoder.should_receive(:content_type).and_return("application/json")
        
        transport = mock("TransportMock")
        transport.should_receive(:encoder).exactly(3).times.and_return(encoder)
        
        service = mock("ServiceMock")
        service.should_receive(:transport).exactly(3).times.and_return(transport)
        ServiceRegistry.should_receive(:locate_service).with("service_name").and_return(service)
        
        Hoth::Services.should_receive(:send).with("service_name", *decoded_params).and_return(service_result = "result")
        encoder.should_receive(:encode).with({"result" => service_result}).and_return("result_encoded")
        
        mock_request = Rack::MockRequest.new(middleware)
        mock_request.post("http://localhost/execute?name=service_name&params=some_parameter")
      end
      
      it "should be able to handle exceptions" do
        app = stub("ApplicationStub").as_null_object
        middleware = Hoth::Providers::RackProvider.new app
        env = {"PATH_INFO" => "/execute/some_method", "other_params" => nil}
        Rack::Request.should_receive(:new).and_raise(RuntimeError)
      
        rack_response = middleware.call env
        rack_response.first.should == 500 #status code
        rack_response.last.should be_a_kind_of(Array)
        rack_response.last.first.should == "An error occuered! (RuntimeError)"
      end
      
    end
    
  end
end