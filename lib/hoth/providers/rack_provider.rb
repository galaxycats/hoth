require 'rack/request'
require 'json'

module Hoth
  module Providers
    class RackProvider

      def initialize(app)
        @app = app
      end

      def call(env)
        if env["PATH_INFO"] =~ /^\/execute/
          begin
            req = Rack::Request.new(env)

            service_name   = req.params["name"]
            service_params = req.params["params"]
            json_payload   = JSON({"result" => Hoth::Services.send(service_name, service_params)})
          
            [200, {'Content-Type' => 'application/json', 'Content-Length' => "#{json_payload.length}"}, json_payload]
          rescue Exception => e
            json_payload = JSON({'error' => e})
            [500, {'Content-Type' => 'application/json', 'Content-Length' => "#{json_payload.length}"}, json_payload]
          end
        else
          @app.call(env)
        end
      end

    end
  end
end