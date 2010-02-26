Hoth::Services.define do
  
  service :increment_statistics, :params => [[:statistic_object], :event],
                                 :returns => nil,
                                 :endpoint => :statistics_module
  
  service :statistic_of_cars, :params => [[:ids]],
                              :returns => [:statistic_data], # this enclosing array means really that an array of statistic_data-objects will be returned
                              :endpoint => :statistics_module
                                      # the enclosing Array is just for specifying the actual parameters.
  service :create_account, :params => [:account],
                           :returns => [:account_id],
                           :endpoint => :accounts_module
end