require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Transport
    describe Http do

      before(:each) do
        @service_mock = mock("ServiceMock")
      end

      it "should call a remote via http" do
        params = {:first_name => "Seras", :last_name => "Victoria"}

        transport = Http.new(@service_mock)
        transport.should_receive(:post_payload).with([params])
        transport.call_remote_with(params)
      end

      it "should post payload encoded with JSON" do
        @service_mock.should_receive(:endpoint).and_return(endpoint = mock("EndpointMock"))
        @service_mock.should_receive(:name).and_return("service_name")
        endpoint.should_receive(:to_url).and_return("http://localhost:3000/execute")

        encoder = mock("JsonEncoderMock")
        encoder.should_receive(:encode).with("params").and_return("encoded_params")

        URI.should_receive(:parse).with("http://localhost:3000/execute").and_return(uri = mock("URIMock"))
        Net::HTTP.should_receive(:post_form).with(uri, {"name" => "service_name", "params" => "encoded_params"})

        transport = Http.new(@service_mock, {:encoder => encoder})
        transport.post_payload("params")
      end

      describe "Error Handling" do

        before(:each) do
          service_mock = mock("ServiceMock")
          @params    = {:first_name => "Seras", :last_name => "Victoria"}
          encoder    = mock("JsonEncoderMock")
          @transport = Http.new(service_mock, {:encoder => encoder})
        end

        it "should handle http connection error" do
          @transport.should_receive(:post_payload).and_raise(Exception)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle successful response" do
          @transport.should_receive(:post_payload).and_return(response = Net::HTTPSuccess.allocate)
          response.should_receive(:body).twice.and_return(response_body = '{"result" : "return_value"}')
          @transport.encoder.should_receive(:decode).with(response_body).and_return({"result" => "return_value"})
          @transport.call_remote_with(@params)
        end

        it "should handle remote server error" do
          @transport.should_receive(:post_payload).and_return(response = Net::HTTPServerError.allocate)
          response.should_receive(:body).any_number_of_times.and_return(response_body = '{"error" : "ServerError"}')
          @transport.encoder.should_receive(:decode).with(response_body).and_return({"result" => "return_value"})
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle any other HTTP errors" do
          [Net::HTTPRedirection, Net::HTTPClientError, Net::HTTPInformation, Net::HTTPUnknownResponse].each do |http_response|
            @transport.should_receive(:post_payload).and_return(response = http_response.allocate)
            response.should_receive(:body).any_number_of_times.and_return('{"error" : "ServerError"}')
            lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
          end
        end

        it "should handle Timeout::Error and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(Timeout::Error)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle Errno::EINVAL and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(Errno::EINVAL)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle Errno::ECONNRESET and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(Errno::ECONNRESET)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle EOFError and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(EOFError)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle Net::HTTPBadResponse and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(Net::HTTPBadResponse)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle Net::HTTPHeaderSyntaxError and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(Net::HTTPHeaderSyntaxError)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle Net::ProtocolError and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(Net::ProtocolError)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle Errno::ECONNREFUSED and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(Errno::ECONNREFUSED)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end

        it "should handle SocketError and wrap them in a TransportError" do
          @transport.should_receive(:post_payload).and_raise(SocketError)
          lambda { @transport.call_remote_with(@params) }.should raise_error(TransportError)
        end
      end
    end

  end
end
