Hoth::Modules.define do
  service_module :statistics_module do
    env :development do
      endpoint :default do
        host '127.0.0.1'
        port 443
        transport :json_via_https
      end
    end
    
    add_service :increment_statistics
    add_service :statistic_of_cars
  end

  service_module :accounts_module do
    env :development do
      endpoint :default do
        host 'localhost'
        port 3000
        transport :http
      end
    
      endpoint :beanstalk do
        host 'localhost'
        port 11300
        transport :beanstalkd
      end
    end
    
    add_service :create_account, :via => :beanstalk
  end
end
