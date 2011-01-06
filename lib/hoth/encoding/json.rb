require 'json'

module Hoth
  module Encoding
    class Json
      
      class <<self
        def encode(object)
          object.to_json
        end

        def decode(string)
          begin
            Hoth::Logger.debug "Original params before decode: #{string.inspect}"
            JSON.parse(string)
          rescue JSON::ParserError => jpe
            raise EncodingError.wrap(jpe)
          end
        end
        
        def content_type
          "application/json"
        end
      end
      
    end
  end
end
