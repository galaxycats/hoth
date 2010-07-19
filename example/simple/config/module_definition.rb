Hoth::Modules.define do
  service_module :math_module do
    env :development do
      endpoint :default do
        host 'localhost'
        port 9292
        transport :json_via_http
      end
    end
    
    add_service :addition
  end
end