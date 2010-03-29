$:.unshift(File.join("..", "lib"))

require 'rubygems'

require 'hoth'
require 'business_objects'

Hoth.init!

statistic_object = StatisticsObject.new(
  :id => 23,
  :owner_id => 42,
  :statistic_type => "Car",
  :timestamp => Time.now,
  :group_condition => nil
)

event = Event.new(:name => "viewed", :count => 2)

puts "call increment_statistics"
Hoth::Services.increment_statistics([statistic_object], event)
puts "done"
# Bert is not working at the moment
# puts Hoth::Services.statistic_of_cars([23, 42, 303, 101]).inspect
# 
# account = Account.new(
#   :firstname => "Dirk",
#   :lastname  => "Breuer",
#   :contract  => "Platinum",
#   :company   => "Galaxy Cats" 
# )
# 
# puts "Account ID: #{Hoth::Services.create_account(account)}"