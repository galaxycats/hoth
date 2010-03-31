module Hoth
  module Encoding
    class NoOp
      
      class <<self
        def encode(string)
          string
        end

        def decode(string)
          string
        end
        
        def content_type; end
      end
      
    end
  end
end