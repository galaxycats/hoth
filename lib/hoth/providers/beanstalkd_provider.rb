begin
  require 'em-jack'
rescue LoadError
  STDERR.puts "You need the 'em-jack' gem if you want to use Beanstalkd provider."
end

module Hoth
  module Providers

    class BeanstalkdProvider
      
      def initialize
        @services_to_listen_for = Hoth::Modules.service_modules.values.inject([]) do |services, service_module|
          services << service_module.registered_services.select do |service|
            service.endpoint.transport == :beanstalkd
          end
          services.flatten
        end
      end

      def listen
        EM.run {
          @services_to_listen_for.each do |service|
            conn_for_service = EMJack::Connection.new(:host => service.endpoint.host, :port => service.endpoint.port)
            conn_for_service.watch(service.transport.tube_name)
            conn_for_service.each_job do |job|
              responsible_service = ServiceRegistry.locate_service(service.name)

              raise ServiceNotFoundException.new("The requested service '#{service.name}' was not found!") if responsible_service.nil?

              begin
                decoded_params = responsible_service.transport.encoder.decode(job.body)
                Rails.logger.debug "decoded_params: #{decoded_params}"
                Hoth::Services.send(service.name, *decoded_params)
              rescue => e
                Rails.logger.warn "An error occured while invoking the service: #{e.message}"
              ensure
                conn_for_service.delete(job)
              end
            end
          end
        } 
      end

    end
    
  end
end
