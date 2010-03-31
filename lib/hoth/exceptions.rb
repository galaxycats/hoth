module Hoth
  class HothException < StandardError
    attr_reader :original
    def self.wrap(original)
      wrapped = new("#{original.class} says: #{original.message}")
      wrapped.set_backtrace original.backtrace
      wrapped.instance_variable_set :@original, original
      wrapped
    end
  end

  class TransportError < HothException; end
  class TransportException < HothException; end
end