require 'json'
require 'net/http'

module Hoth
  module Transport
    class Http < Base     
      def call_remote_with(*params)
        unless return_nothing?
          begin
            handle_response post_payload(params)
          rescue Exception => e
            raise TransportError.wrap(e)
          end
        else
          return nil
        end
      end
      
      # TODO move to encoder class
      def decode_params(params)
        Hoth::Logger.debug "Original params before decode: #{params.inspect}"
        JSON.parse(params)
      rescue JSON::ParserError => jpe
        raise TransportError.wrap(jpe)
      end
      
      def handle_response(response)
        case response
        when Net::HTTPSuccess
          Hoth::Logger.debug "response.body: #{response.body}"
          JSON.parse(response.body)["result"]
        when Net::HTTPServerError
          begin
            Hoth::Logger.debug "response.body: #{response.body}"
            raise JSON.parse(response.body)["error"]
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
          'name'   => self.name.to_s,
          'params' => payload.to_json # TODO substitute with Encoder class
        )
      end
      
    end
  end
end
