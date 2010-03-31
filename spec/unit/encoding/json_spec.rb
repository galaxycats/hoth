require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Encoding
    
    describe Json do
      
      it "should decode a JSON string" do
        decoded_json = Json.decode '{"test":23}'
        decoded_json.should ==({"test" => 23})
      end
      
      it "should encode a JSON string" do
        encoded_json = Json.encode({"test" => 23})
        '{"test":23}'.should == encoded_json
      end
      
      it "should know its ContentType" do
        Json.content_type.should == "application/json"
      end
      
    end
    
  end
end
