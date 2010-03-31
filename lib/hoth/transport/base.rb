require 'forwardable'
 
module Hoth
  module Transport
    class Base
      extend Forwardable
      
      attr_reader :encoding_class
      
      def_delegators :@service_delegate, :name, :module, :endpoint, :params, :return_nothing?
      
      def initialize(service_delegate, options = {})
        @service_delegate = service_delegate
        @encoding_class = options[:encoding_class]
      end
      
    end
  end
end