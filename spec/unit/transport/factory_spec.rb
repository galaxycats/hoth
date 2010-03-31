require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

module Hoth
  module Transport
    describe Factory do
    
      it "should create a new transport by transport name for a given service" do
        service = mock("ServiceMock")
        Factory.should_receive(:new_transport_with_encoding).with(:transport_name, service)
        Factory.create(:transport_name, service)
      end
      
      it "should create a new transport instance with encoding from a transport name" do
        transport = Factory.send(:new_transport_with_encoding, :json_via_http, mock("ServiceMock"))
        transport.should be_kind_of(Transport::Http)
        transport.encoder.should == Encoding::Json
      end
      
      it "should create a new transport instance with encoding from a transport alias" do
        transport = Factory.send(:new_transport_with_encoding, :http, mock("ServiceMock"))
        transport.should be_kind_of(Transport::Http)
        transport.encoder.should == Encoding::Json
      end
      
      it "should raise an exception if transport name does not exist" do
        lambda { Factory.send(:new_transport_with_encoding, :not_existing_transport, mock("ServiceMock")) }.should raise_error(TransportFactoryException)
      end
      
    end
  end
end