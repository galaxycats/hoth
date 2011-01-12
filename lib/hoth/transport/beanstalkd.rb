begin
  require 'beanstalk-client'
rescue LoadError
  STDERR.puts "You need the 'beanstalk-client' gem if you want to use Beanstalkd transport."
end

module Hoth
  module Transport

    class Beanstalkd < Base

      def call_remote_with(*args)
        connection = Beanstalk::Pool.new(["#{endpoint.host}:#{endpoint.port}"])
        connection.use(tube_name)

        encoded_args = encoder.encode(args)
        Rails.logger.debug "encoded_args: #{encoded_args}"
        connection.put encoded_args
      end

      def tube_name
        @tube_name ||= "#{self.module.name}/#{name}".dasherize
      end
      
    end
    
  end
end
