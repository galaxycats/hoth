require 'forwardable'
 
module Hoth
  module Transport
    class Base
      extend Forwardable
      
      attr_reader :encoder
      
      def_delegators :@service_delegate, :name, :module, :endpoint, :params, :return_nothing?
      
      def initialize(service_delegate, options = {})
        @service_delegate = service_delegate
        @encoder = options[:encoder] || Encoding::NoOp
      end
      
    end
  end
end