require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Transport
    
    describe "Base" do
      
      it "should initialize with service-delegate" do
        service = mock("ServiceMock")
        transport = Base.new(service)
      end
      
      it "should delegate calls to service-delegate" do
        service = mock("ServiceMock")
        service.should_receive(:name)
        service.should_receive(:module)
        service.should_receive(:endpoint)
        service.should_receive(:params)
        service.should_receive(:return_value)
        transport = Base.new(service)
        
        [:name, :module, :endpoint, :params, :return_value].each do |method|
          transport.send(method)
        end
        
      end
            
    end
    
  end
end