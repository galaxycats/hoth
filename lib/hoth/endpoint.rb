module Hoth
  class Endpoint
    attr_accessor :host, :port, :transport_type

    def initialize(attributes)
      @host           = attributes[:host]
      @port           = attributes[:port]
      @transport_type = attributes[:transport_type]
    end

    def ==(endpoint)
      self.host == endpoint.host &&
        self.port == endpoint.port
    end

    def to_url
      "http://#{@host}:#{@port}/execute"
    end
    
    def is_local?
      ENV["LOCAL"] == "true" ? true : false # make dynamic
    end
  end
end