ENV["LOCAL"] = "true"

$:.unshift(File.join("..", "lib"))

require 'rubygems'

require 'hoth'
require 'hoth/providers/rack_provider'
require 'deployment_definition'
require 'service_definition'
require 'business_objects'
require 'rack'

class IncrementStatisticsImpl
  def self.execute(statistic_objects, event)
    puts "** EXECUTING IncrementStatisticsImpl"
    puts "   statistic_objects: #{statistic_objects.inspect}"
    puts "   events: #{event.inspect}"
  end
end

class StatisticOfCarsImpl
  def self.execute(ids)
    puts "** EXECUTING IncrementStatisticsImpl"
    puts "   ids: #{ids}"
    return [StatisticData.new(:event => Event.new(:name => "viewed", :count => 101),
                              :original_id => 300)]
  end
end

app = lambda {|env| [200, {'Content-Type' => 'application/json'}, ""]}

run Hoth::Providers::RackProvider.new(app)

# class IncrementStatisticsImpl
#   def self.execute(elements)
#     elements.each do |element|
#       Statistic.find_or_create_by_name(element).increment!(:count)
#     end
#   end
# end
# 
# class StatisticForImpl
#   def self.execute(element_names)
#     Statistic.find_all_by_name(element_names)
#   end
# end