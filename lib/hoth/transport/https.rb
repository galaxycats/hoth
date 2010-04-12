require 'net/http'
require 'net/https'

module Hoth
  module Transport
    class Https < Http
      def post_payload(payload)
        uri = URI.parse(self.endpoint.to_url)
        
        post = Net::HTTP::Post.new(uri.path)
        
        post.set_form_data({
            'name'   => self.name.to_s,
            'params' => encoder.encode(payload)
        }, ';')
        
        request = Net::HTTP.new(uri.host, uri.port)
        request.use_ssl = true
        response = request.start {|http| http.request(post) }
        
        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          response
        else
          response.error!
        end
      end
    end
  end
end