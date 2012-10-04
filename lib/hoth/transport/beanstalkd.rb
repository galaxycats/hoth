begin
  require 'beanstalk-client'
rescue LoadError
  STDERR.puts "You need the 'beanstalk-client' gem if you want to use Beanstalkd transport."
end

module Hoth
  module Transport

    class Beanstalkd < Base

      attr_reader :connection

      def initialize(*args)
        super
        @connection = Beanstalk::Connection.new("#{endpoint.host}:#{endpoint.port}")
      end

      def call_remote_with(*args)
        connection.use(tube_name)

        begin
          encoded_args = encoder.encode(args)
          Hoth::Logger.debug "encoded_args: #{encoded_args}"
          connection.put encoded_args
        rescue => e
          Hoth::Logger.warn "An error occured while sending a payload to beanstalkd: #{e.message}"
        end
      end

      def tube_name
        @tube_name ||= "#{self.module.name}/#{name}".dasherize
      end

    end

  end
end
