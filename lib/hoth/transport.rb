require 'hoth/transport/base'
require 'hoth/transport/http'
require 'hoth/transport/https'
require 'hoth/transport/beanstalkd'

require 'hoth/encoding/json'
require 'hoth/encoding/no_op'

module Hoth
  module Transport
    
    POSSIBLE_TRANSPORTS = {
      :json_via_http => {
        :transport_class => Transport::Http,
        :encoder => Encoding::Json
      },
      :http => :json_via_http,

      :json_via_https => {
        :transport_class => Transport::Https,
        :encoder => Encoding::Json
      },
      :https => :json_via_https,

      :beanstalkd => {
        :transport_class => Transport::Beanstalkd,
        :encoder => Encoding::Json
      }
    }
    
    class <<self
      def create(transport_name, service)
        new_transport_with_encoding(transport_name, service)
      end

      def new_transport_with_encoding(transport_name, service)
        if POSSIBLE_TRANSPORTS[transport_name.to_sym]
          if POSSIBLE_TRANSPORTS[transport_name.to_sym].kind_of?(Hash)
            POSSIBLE_TRANSPORTS[transport_name.to_sym][:transport_class].new(service, :encoder => POSSIBLE_TRANSPORTS[transport_name.to_sym][:encoder])
          else
            new_transport_with_encoding(POSSIBLE_TRANSPORTS[transport_name.to_sym], service)
          end
        else
          raise TransportException.new("specified transport '#{transport_name}' does not exist, use one of these: #{POSSIBLE_TRANSPORTS.keys.join(", ")}")
        end
      end
    end
    
  end
end
