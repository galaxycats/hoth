require 'ernie'

module Hoth
  module Providers
    class BertRPCProvider
      
      def self.create_ernie_definition
        Ernie.log "Possible Service implementations: #{Object.constants.grep(/.*Impl$/).inspect}"
        Object.constants.grep(/.*Impl$/).each do |impl_class_name|
          if impl_class = Object.const_get(impl_class_name) #&& impl_class.respond_to?(:execute)
            Ernie.log "Service implementation was loaded! (#{impl_class.inspect})"
            if impl_class.respond_to?(:execute)
              service_name = impl_class_name.gsub("Impl", "").underscore.to_sym
              mod(service_name) do
                fun(:execute) do |*args|
                  return_value = begin
                    Hoth::Transport::BertTransport::TuplePreparer.prepare(Hoth::Services.send(service_name, *args))
                  rescue Exception => e
                    Ernie.log %Q{An Exception occured: #{e.message} -- #{e.backtrace.join("\n\t")}}
                    false
                  end
                end
              end
            else
              Ernie.log "Implementation wasn't applicatable. :execute method is missing!"
            end
          else
            Ernie.log "Service implementation was not loaded! (#{impl_class_name.inspect})"
          end
        end
      end

    end
  end
end