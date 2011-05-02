require 'rack/request'

module Hoth
  module Providers
    class RackProvider

      def initialize(app=nil)
        @app = app || lambda {|env| [404, {'Content-Type' => "text/plain"}, ["Nothing here!"]]}
      end

      def call(env)
        if env["PATH_INFO"] =~ /^\/execute/
          begin
            req = Rack::Request.new(env)

            service_name   = req.params["name"]
            service_params = req.params["params"]

            raise EmptyServiceNameError.new("You must provide a service name!") if service_name.nil?

            responsible_service = ServiceRegistry.locate_service(service_name)

            raise ServiceNotFoundException.new("The requested service '#{service_name}' was not found!") if responsible_service.nil?

            # check if we have called ourself
            raise RecursiveServiceCallException.new("Service caller and callee have the same Client-UUID!") if req.params["caller_uuid"] == Hoth.client_uuid

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
              [e.class == ServiceNotFoundException ? 404 : 500, {'Content-Type' => "text/plain", 'Content-Length' => "#{plain_error.length}"}, [plain_error]]
            end
          end
        else
          @app.call(env)
        end
      end

    end
  end
end
