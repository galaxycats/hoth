require 'spec_helper'

describe Hoth do
  
  before(:each) do
    @old_hoth_env = Hoth.env
    Hoth.instance_variable_set "@env", nil
  end
  
  after(:each) do
    Hoth.env = @old_hoth_env
  end
  
  it "should set the environment explicitly" do
    Hoth.env = :test
    Hoth.env.should == :test
  end
  
  it "should default to :development if no environment is set" do
    Hoth.env.should equal(:development)
  end
  
  it "should return the Rails env if Rails is available" do
    module Rails; end
    Rails.should_receive(:env).and_return(:production)
    Hoth.env.should equal(:production)
    Object.send :remove_const, :Rails
  end
  
end