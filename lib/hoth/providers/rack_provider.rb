require 'rack/request'

module Hoth
  module Providers
    class RackProvider

      def initialize(app)
        @app = app
      end

      def call(env)
        Hoth::Logger.debug "env: #{env.inspect}"
        if env["PATH_INFO"] =~ /^\/execute/
          begin
            req = Rack::Request.new(env)

            service_name   = req.params["name"]
            service_params = req.params["params"]

            raise EmptyServiceNameError.new("You must provide a service name!") if service_name.nil?

            responsible_service = ServiceRegistry.locate_service(service_name)

            raise ServiceNotFoundException.new("The requested service was not found!") if responsible_service.nil?

            decoded_params = responsible_service.transport.encoder.decode(service_params)
            result = Hoth::Services.send(service_name, *decoded_params)

            encoded_result = responsible_service.transport.encoder.encode({"result" => result})

            [200, {'Content-Type' => responsible_service.transport.encoder.content_type, 'Content-Length' => "#{encoded_result.length}"}, [encoded_result]]
          rescue Exception => e
            Hoth::Logger.error "e: #{e.message}"
            if responsible_service
              encoded_error = responsible_service.transport.encoder.encode({"error" => e})
              [500, {'Content-Type' => responsible_service.transport.encoder.content_type, 'Content-Length' => "#{encoded_error.length}"}, [encoded_error]]
            else
              plain_error = "An error occurred! (#{e.message})"
              [500, {'Content-Type' => "text/plain", 'Content-Length' => "#{plain_error.length}"}, [plain_error]]
            end
          end
        else
          @app.call(env)
        end
      end

    end
  end
end