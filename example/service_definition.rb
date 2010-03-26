Hoth::Services.define do
  
  service :increment_statistics do |statistic_objects, event|
    returns :nothing
  end
  
  service :statistic_of_cars do |ids|
    returns :statistic_datas
  end
  
  service :create_account do |account|
    returns :account_ids
  end
  
end