require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hoth::Endpoint do
  
  it "should have a port" do
    endpoint = Hoth::Endpoint.new { port 3000 }
    endpoint.port.should == 3000
  end
  
  it "should have a host name" do
    endpoint = Hoth::Endpoint.new { host "example.com" }
    endpoint.host.should == "example.com"
  end
  
  it "should have a transport type" do
    endpoint = Hoth::Endpoint.new { transport_type :json }
    endpoint.transport_type.should == :json
  end
  
  it "should should cast itself to URL string" do
    endpoint = Hoth::Endpoint.new { port 3000; host "example.com" }
    endpoint.to_url.should == "http://example.com:3000/execute"
  end
    
  it "should should know the deployment module this endpoint is associated to" do
    endpoint = Hoth::Endpoint.new { module_name "TestModule" }
    endpoint.module_name.should == "TestModule"
  end
  
end