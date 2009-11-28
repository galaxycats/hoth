Hoth::Services.define do
  
  service :increment_statistics, :params => [[:statistic_object], :event],
                                 :returns => nil,
                                 :endpoint => :statistics_module
  
  service :statistic_of_cars, :params => [[:ids]],
                              :returns => [:statistic_data],
                              :endpoint => :statistics_module
  
  service :create_account, :params => [:account],
                           :returns => [:account_id],
                           :endpoint => :accounts_module
  
end