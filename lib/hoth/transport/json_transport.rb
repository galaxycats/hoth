require 'json'
require 'net/http'

module Hoth
  module Transport
    class JsonTransport < HothTransport
      
      def call_remote_with(*args)
        response = Net::HTTP.post_form(
          URI.parse(self.endpoint.to_url),
          { 'name' => self.name.to_s, 'params' => "#{args.to_json}" }
        )
        
        if self.return_value
          case response
          when Net::HTTPSuccess then JSON.parse(response.body)
          else
            raise JSON.parse(response.body)
          end
        else
          response.is_a?(Net::HTTPSuccess) ? true : false
        end
      end
      
      def decode_params(params)
        puts "params: #{params.inspect}"
        JSON.parse(params)
      end
      
    end
  end
end