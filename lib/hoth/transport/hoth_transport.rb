require 'forwardable'

module Hoth
  module Transport
    class HothTransport
      extend Forwardable
      
      def_delegators :@service_delegate, :name, :endpoint, :params, :return_value
      
      def initialize(service_delegate)
        @service_delegate = service_delegate
      end
      
    end
  end
end