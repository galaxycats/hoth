ENV["LOCAL"] = "true"

$:.unshift(File.join("..", "lib"))

require 'rubygems'
require 'hoth'
require 'hoth/providers/bertrpc_provider'
require 'deployment_definition'
require 'service_definition'
require 'business_objects'

require 'digest/sha1'

class CreateAccountImpl
  def self.execute(account)
    Ernie.log "** EXECUTING CreateAccountImpl"
    Ernie.log "   account: #{account.inspect}"

    return Digest::SHA1.hexdigest("#{account}-#{Time.now}")
  end
end

Ernie.logfile("/tmp/ernie.log")

Hoth::Providers::BertRPCProvider.create_ernie_definition

