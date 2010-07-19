# to run this provider, use: rackup simple_provider.ru

$:.unshift(File.join("..", "..", "lib"))

require 'rubygems'

require 'rack'
require 'hoth'
require 'hoth/providers/rack_provider'

require "logger"

# Initialize Hoth, load service and module definitions
Hoth.init!

# Example, how you can specify your own log provider
Hoth::Logger.log_provider = Logger.new(STDOUT)
Hoth::Logger.log_provider.level = Logger::WARN

# To implement the service "addition", we need to provide AdditionImpl.execute
class AdditionImpl
  def self.execute(a, b)
    return a + b
  end
end

# here we go!
app = lambda {|env| [200, {'Content-Type' => 'application/json'}, ["body"]]}
rack_thread = Thread.new { run Hoth::Providers::RackProvider.new(app) }
rack_thread.join
