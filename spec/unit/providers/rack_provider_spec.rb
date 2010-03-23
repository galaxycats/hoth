require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

require File.expand_path(File.join(File.dirname(__FILE__), '../../../',  'lib', 'hoth', 'providers', 'rack_provider'))

describe Hoth::Providers::RackProvider do
  it "should be able to handle exceptions" do
    app = stub("ApplicationStub").as_null_object
    middleware = Hoth::Providers::RackProvider.new app
    env = {"PATH_INFO" => "/execute/some_method", "other_params" => nil}
    Rack::Request.should_receive(:new).and_raise(RuntimeError)
    
    rack_response = middleware.call env
    rack_response.first.should == 500 #status code
    rack_response.last.should match('json_class')
    rack_response.last.should match('RuntimeError')
  end
end