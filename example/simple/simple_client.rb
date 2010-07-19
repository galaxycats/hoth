# the client requires you to have a running provider (see simple_provider.ru)

$:.unshift(File.join("..", "..", "lib"))

require 'rubygems'

require 'hoth'

# first we initialize Hoth (this will load the configuration as well)
Hoth.init!

# let's call the "addition" service and show the result!
puts Hoth::Services.addition(40, 2)
# => 42

# Next, we will implement addition locally...
class AdditionImpl
  def self.execute(a, b)
    puts "I'm local!"
    return a + b
  end
end

# And call the service locally!
puts Hoth::Services.addition(1, 2)
# => I'm local!
# => 3