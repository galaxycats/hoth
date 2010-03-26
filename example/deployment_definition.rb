Hoth::ServiceDeployment.define do
  service_module :statistics_module do
    env :development do
      endpoint :default,
        :host => 'localhost',
        :port => 3000,
        :transport_type => :http

    end
    
    add_service :increment_statistics
    add_service :statistic_of_cars
  end

  service_module :accounts_module do
    env :development do
      endpoint :default,
        :host => 'localhost',
        :port => 3000,
        :transport_type => :http
    
      endpoint :bert,
        :host => 'localhost',
        :port => 9999,
        :transport_type => :bert
    
    end
    
    add_service :create_account, :via => :bert
  end
end