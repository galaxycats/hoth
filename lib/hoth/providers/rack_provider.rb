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
          req = Rack::Request.new(env)

          service_name   = req.params["name"]
          service_params = JSON.parse(req.params["params"])
          return_value   = Hoth::Services.send(service_name, *service_params)

          [200, {'Content-Type' => 'application/json'}, return_value.to_json]
        else
          @app.call(env)
        end
      end

    end
  end
end