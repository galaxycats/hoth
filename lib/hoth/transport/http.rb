require 'json'
require 'net/http'

module Hoth
  module Transport
    class Http < Base     
      def call_remote_with(*params)
        
        unless return_nothing?
          case post_payload(params)
          when Net::HTTPSuccess
            Hoth::Logger.debug "response.body: #{response.body}"
            JSON(response.body)["result"]
          when Net::HTTPServerError
            begin
              raise JSON(response.body)["error"]
            rescue JSON::ParserError => jpe
              raise TransportError.wrap(jpe)
            end
          when Net::HTTPRedirection, Net::HTTPClientError, Net::HTTPInformation, Net::HTTPUnknownResponse
            #TODO Handle redirects(3xx) and http errors(4xx), http information(1xx), unknown responses(xxx)
            raise NotImplementedError, "HTTP code: #{response.code}, message: #{response.message}"
          end
        end       
      end
      
      # TODO move to encoder class
      def decode_params(params)
        Hoth::Logger.debug "Original params before decode: #{params.inspect}"
        JSON.parse(params)
      rescue JSON::ParserError => jpe
        raise TransportError.wrap(jpe)
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
