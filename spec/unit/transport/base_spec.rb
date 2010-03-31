require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Transport
    
    describe "Base" do
      
      it "should initialize with service-delegate" do
        service = mock("ServiceMock")
        transport = Base.new(service)
      end
      
      it "should use an NoOp encoder if no encoder class was given at all" do
        service = mock("ServiceMock")
        transport = Base.new(service)
        transport.encoder.should == Encoding::NoOp
      end
      
      it "should delegate calls to service-delegate" do
        service = mock("ServiceMock")
        service.should_receive(:name)
        service.should_receive(:module)
        service.should_receive(:endpoint)
        service.should_receive(:params)
        service.should_receive(:return_nothing?)
        transport = Base.new(service)
        
        [:name, :module, :endpoint, :params, :return_nothing?].each do |method|
          transport.send(method)
        end
      end
      
      it "should have an encoder" do
        service = mock("ServiceMock")
        encoder = mock("EncoderMock")
        transport = Base.new(service, :encoder => encoder)
        transport.encoder.should be(encoder)
      end
            
    end
    
  end
end