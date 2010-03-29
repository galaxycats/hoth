$:.unshift(File.join("..", "lib"))

require 'rubygems'
require 'hoth'
require 'hoth/providers/bertrpc_provider'
require 'business_objects'

require 'digest/sha1'

Hoth.init!

class CreateAccountImpl
  def self.execute(account)
    Ernie.log "** EXECUTING CreateAccountImpl"
    Ernie.log "   account: #{account.inspect}"

    return Digest::SHA1.hexdigest("#{account}-#{Time.now}")
  end
end

Ernie.logfile("ernie.log")

Hoth::Providers::BertRPCProvider.create_ernie_definition