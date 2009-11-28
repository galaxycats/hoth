require 'bert'
require 'bertrpc'

module Hoth
  module Transport
    class BertTransport < HothTransport
      
      def call_remote_with(*args)
        bert_service = BERTRPC::Service.new(self.endpoint.host, self.endpoint.port)
        
        response = bert_service.call.send(self.name.to_s).execute
        
        if self.return_value
          return BERT.decode(response)
        else
          return true
        end
      end
      
    end
  end
end