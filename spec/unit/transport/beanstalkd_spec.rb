require File.expand_path(File.join(File.dirname(__FILE__), '../../',  'spec_helper'))

module Hoth
  module Transport

    describe "Beanstalkd" do
      before(:each) do
        endpoint = mock("EndpointMock")
        endpoint.stub(:host).and_return("localhost")
        endpoint.stub(:port).and_return("11300")

        service_module = mock("ServiceModule")
        service_module.should_receive(:name).and_return(:test_service_module)

        @service = mock("ServiceMock")
        @service.should_receive(:name).and_return(:test_service)
        @service.should_receive(:endpoint).any_number_of_times.and_return(endpoint)
        @service.should_receive(:module).any_number_of_times.and_return(service_module)

        @beanstalk_connection = mock("Beanstalk::Connection")
      end

      it "should send the payload over an existing Beanstalk::Connection and don't close it afterwards" do
        Beanstalk::Connection.should_receive(:new).with("localhost:11300").once.and_return(@beanstalk_connection)
        @beanstalk_connection.should_receive(:use).with(anything).any_number_of_times
        @beanstalk_connection.should_receive(:put).with(["some_data_to_send"])
        @beanstalk_connection.should_receive(:put).with(["some_more_data_to_send"])
        @beanstalk_connection.should_receive(:close).never

        transport = Beanstalkd.new(@service)
        transport.call_remote_with("some_data_to_send")
        transport.call_remote_with("some_more_data_to_send")
      end

      it "should use the beanstalk tube specified by the transport" do
        Beanstalk::Connection.should_receive(:new).with("localhost:11300").and_return(@beanstalk_connection)
        transport = Beanstalkd.new(@service)
        @beanstalk_connection.should_receive(:use).with(transport.tube_name)
        @beanstalk_connection.should_receive(:put).with(["some_data_to_send"])
        @beanstalk_connection.should_receive(:close).never

        transport.call_remote_with("some_data_to_send")
      end

      it "should define the tube_name according to the module and service name" do
        transport = Beanstalkd.new(@service)
        transport.tube_name.should == "test-service-module/test-service"
      end
    end

  end
end
