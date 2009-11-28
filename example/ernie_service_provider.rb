ENV["LOCAL"] = "true"

$:.unshift(File.join("..", "lib"))

require 'rubygems'

require 'hoth'
require 'hoth/providers/rack_provider'
require 'deployment_definition'
require 'service_definition'
require 'business_objects'

require 'digest/sha1'

class CreateAccountImpl
  def self.execute(account)
    puts "** EXECUTING CreateAccountImpl"
    puts "   account: #{account.inspect}"

    return Digest::SHA1.hexdigest("#{account}-#{Time.now}")
  end
end
