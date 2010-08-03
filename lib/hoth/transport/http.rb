require 'net/http'

module Hoth
  module Transport
    class Http < Base     
      def call_remote_with(*params)
        begin
          handle_response post_payload(params)
        rescue Exception => e
          raise TransportError.wrap(e)
        end
      end
      
      def handle_response(response)
        case response
        when Net::HTTPSuccess
          Hoth::Logger.debug "response.body: #{response.body}"
          encoder.decode(response.body)["result"]
        when Net::HTTPServerError
          begin
            Hoth::Logger.debug "response.body: #{response.body}"
            raise encoder.decode(response.body)["error"]
          rescue JSON::ParserError => jpe
            raise TransportError.wrap(jpe)
          end
        when Net::HTTPRedirection, Net::HTTPClientError, Net::HTTPInformation, Net::HTTPUnknownResponse
          raise NotImplementedError, "code: #{response.code}, message: #{response.body}"
        end
      end
      
      def post_payload(payload)
        uri = URI.parse(self.endpoint.to_url)
        return Net::HTTP.post_form(uri,
          'name'        => self.name.to_s,
          'caller_uuid' => Hoth.client_uuid,
          'params'      => encoder.encode(payload)
        )
      end
      
    end
  end
end
