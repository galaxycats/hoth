module Hoth
  module Transport
    class Factory
      
      POSSIBLE_TRANSPORTS = {
        :json_via_http => {
          :transport_class => Transport::Http,
          :encoder => Encoding::Json
        },
        :http => :json_via_http,
        :workling => {
          :transport_class => Transport::Workling
        }
      }
      
      def self.create(transport_name, service)
        new_transport_with_encoding(transport_name, service)
      end
      
      private

        def self.new_transport_with_encoding(transport_name, service)
          if POSSIBLE_TRANSPORTS[transport_name.to_sym]
            if POSSIBLE_TRANSPORTS[transport_name.to_sym].kind_of?(Hash)
              POSSIBLE_TRANSPORTS[transport_name.to_sym][:transport_class].new(service, :encoder => POSSIBLE_TRANSPORTS[transport_name.to_sym][:encoder])
            else
              new_transport_with_encoding(POSSIBLE_TRANSPORTS[transport_name.to_sym], service)
            end
          else
            raise TransportFactoryException.new("specified transport '#{transport_name}' does not exist, use one of these: #{POSSIBLE_TRANSPORTS.keys.join(", ")}")
          end
        end
      
    end
  end
end