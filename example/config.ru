$:.unshift(File.join("..", "lib"))

require 'rubygems'

require 'rack'
require 'hoth'
require 'hoth/providers/rack_provider'
require 'business_objects'

Hoth.init!

class IncrementStatisticsImpl
  def self.execute(statistic_objects, event)
    puts "** EXECUTING IncrementStatisticsImpl"
    puts "   statistic_objects: #{statistic_objects.inspect}"
    puts "   events: #{event.inspect}"
  end
end

class StatisticOfCarsImpl
  def self.execute(ids)
    puts "** EXECUTING StatisticOfCarsImpl"
    puts "   ids: #{ids.inspect}"
    
    return ids.inject([]) do |data, id|
      data << StatisticData.new(
        :events       => [Event.new(:name => "viewed", :count => rand(666))],
        :original_id => id
      )
    end
  end
end

app = lambda {|env| [200, {'Content-Type' => 'application/json'}, ""]}

run Hoth::Providers::RackProvider.new(app)