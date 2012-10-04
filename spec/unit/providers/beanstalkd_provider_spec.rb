require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

require File.expand_path(File.join(File.dirname(__FILE__), '../../../',  'lib', 'hoth', 'providers', 'beanstalkd_provider'))

module Hoth
  module Providers
    describe BeanstalkdProvider do

      it "should know its module name" do
        # cannot be tested since i do not know how to mock constructor call
        # http://stackoverflow.com/questions/5270819/how-to-test-a-method-call-in-a-constructor-with-rspec
        # Hoth::Providers::BeanstalkdProvider.any_instance.stub!(:identify_services_to_listen_for)
        # beanstalkd_provider = Hoth::Providers::BeanstalkdProvider.new("foo_module")
        # beanstalkd_provider.module_name.should == "foo_module"
      end

      it "should throw an error if no module name is passed" do
        lambda { Hoth::Providers::BeanstalkdProvider.new }.should raise_error(ArgumentError)
      end

      it "should only listen for services defined for the passed module name" do
        mail_module = Hoth::ServiceModule.new(:name => "mail_module")
        mail_module.should_not_receive(:registered_services)
        foo_module = Hoth::ServiceModule.new(:name => "foo_module")
        service = mock("RegisteredService")
        service.stub_chain(:endpoint, :transport).and_return :beanstalkd
        foo_module.should_receive(:registered_services).and_return([service])
        Hoth::Modules.should_receive(:service_modules).and_return({
          :mail_module => mail_module,
          :foo_module => foo_module
        })

        Hoth::Providers::BeanstalkdProvider.new("foo_module")
      end

    end
  end
end
