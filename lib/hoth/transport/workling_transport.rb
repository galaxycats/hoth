begin
  require 'simple_publisher'
rescue LoadError
  STDERR.puts "You need the simple_publisher gem if you want to use Workling/Starling transport."
end





module Hoth
  module Transport
    
    class WorklingTransport < HothTransport
      
      def call_remote_with(*args)
        topic      = SimplePublisher::Topic.new(:name => "#{self.module.name.to_s.underscore}_subscribers__#{name.to_s.underscore}")
        connection = SimplePublisher::StarlingConnection.new(:host => endpoint.host, :port => endpoint.port)

        publisher = SimplePublisher::Publisher.new(:topic => topic, :connection => connection)
        publisher.publish(args)
      end
      
      def decode_params(*params)
        params
      end
      
    end
    
  end
end