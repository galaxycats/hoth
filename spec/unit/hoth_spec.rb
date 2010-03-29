require 'spec_helper'

describe Hoth do
  
  it "should know its environment" do
    Hoth.env.should equal(:test)
    
    # special env
    Hoth.env = "special_env"
    Hoth.env.should equal(:special_env)
    
    # default
    Hoth.instance_variable_set("@env", nil)
    Hoth.env.should equal(:development)
    
    # get Rails.env
    class Rails; def self.env; :production; end;end
    Hoth.env.should equal(:production)
  end
  
end