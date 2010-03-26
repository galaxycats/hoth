require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

class TestServiceImpl
  def self.execute(param1, param2)
    
  end
end

module Hoth
  
  describe Service do
  
    before(:each) do
      ServiceDeployment.should_receive(:module).
                              and_return({:test => stub(:endpoint => stub("Endpoint"))})
    
      @service = Service.new("TestService",
        :endpoint => "test_module",
        :params   => ["parameter", "another_parameter"],
        :returns  => [:some_data]
      )
    end
  
    it "should define parameters and return values" do
      ServiceDeployment.should_receive(:module).
                              and_return({:test => stub(:endpoint => stub("Endpoint"))})
    
      service = Service.new("TestService",
        :endpoint => "test_module",
        :params   => ["parameter", "another_parameter"],
        :returns  => [:some_data]
      )
    
      service.params.should == ["parameter", "another_parameter"]
      service.return_value.should == [:some_data]
    end
  
    it "should execute the service stub locally based on the endpoint" do
      @service.should_receive(:endpoint).and_return(mock("Endpoint", :is_local? => true))
      transport_mock = mock("HothTranport")
      transport_mock.should_receive(:decode_params).
                     with(:arg1, :arg2).
                     and_return([:decoded_arg1, :decoded_arg2])
                   
      @service.should_receive(:transport).and_return(transport_mock)
    
      @service.execute(:arg1, :arg2)
    end
  
    it "should execute the service stub via transport based on the endpoint" do
    
    end
  
    it "should create transport instance based on endpoint" do
    
    end
  
  end
  
end