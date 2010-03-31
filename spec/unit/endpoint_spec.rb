require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

module Hoth
  
  describe Endpoint do
  
    it "should have a port" do
      endpoint = Endpoint.new { port 3000 }
      endpoint.port.should == 3000
    end
  
    it "should have a host name" do
      endpoint = Endpoint.new { host "example.com" }
      endpoint.host.should == "example.com"
    end
  
    it "should have a transport name" do
      endpoint = Endpoint.new { transport :json_via_http }
      endpoint.transport.should == :json_via_http
    end
  
    it "should should cast itself to URL string" do
      endpoint = Endpoint.new { port 3000; host "example.com" }
      endpoint.to_url.should == "http://example.com:3000/execute"
    end
    
    it "should should know the deployment module this endpoint is associated to" do
      endpoint = Endpoint.new { module_name "TestModule" }
      endpoint.module_name.should == "TestModule"
    end
  
  end
  
end