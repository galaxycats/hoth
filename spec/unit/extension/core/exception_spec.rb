require File.expand_path(File.join(File.dirname(__FILE__), '../../../',  'spec_helper'))

describe Exception do
  
  it "should be able to create json with empty backtrace" do
    e = Exception.new "message"
    e.to_json.should == "{\"json_class\":\"Exception\",\"message\":\"message\",\"backtrace\":null}"
  end
  
  it "should be able to create json with backtrace" do
    e = Exception.new "message"
    e.set_backtrace ["back", "trace"]
    e.to_json.should == "{\"json_class\":\"Exception\",\"message\":\"message\",\"backtrace\":[\"back\",\"trace\"]}"
  end
  
  it "should be able to deserialize exception from json" do
    e = Exception.new "message"
    e.set_backtrace ["back", "trace"]
    deserialized = JSON(e.to_json)
    deserialized.message.should == "message"
    deserialized.backtrace.should == ["back", "trace"]
  end
  
  it "should be able to serialize and deserialize descendants of the Exception class" do
    class ExceptionSpec <  Exception; end
    e = ExceptionSpec.new "message"
    e.set_backtrace ["back", "trace"]
    deserialized = JSON(e.to_json)
    deserialized.message.should == "message"
    deserialized.backtrace.should == ["back", "trace"]
    deserialized.should be_a ExceptionSpec
  end
  
end
