module Hoth
  class Endpoint
    attr_accessor :host, :port, :module_name, :transport_type
    
    class ConfigEvaluator
      attr_reader :endpoint
      def initialize(endpoint, &block)
        @endpoint = endpoint
        instance_eval(&block)
      end
      
      [:host, :port, :module_name, :transport_type].each do |endpoint_attribute|
        define_method endpoint_attribute do |value|
          endpoint.send("#{endpoint_attribute}=", value)
        end
      end
    end
    
    def initialize(&block)
      ConfigEvaluator.new(self, &block)
    end
    
    def to_url
      "http://#{@host}:#{@port}/execute"
    end
  end
end