require 'singleton'

require 'active_support/inflector'

require 'hoth/transport/base'
require 'hoth/transport/http'
require 'hoth/transport/bert'
require 'hoth/transport/workling'

require 'hoth/encoding/base'
require 'hoth/encoding/json'

# must be loaded after alls transports and all encodings
require 'hoth/transport/factory'

require 'hoth/service_definition'
require 'hoth/service_module'
require 'hoth/endpoint'
require 'hoth/service'
require 'hoth/modules'
require 'hoth/service_registry'
require 'hoth/services'

require 'hoth/util/logger'

require 'hoth/extension/core/exception'
require 'hoth/exceptions'

module Hoth
  
  class <<self
    def init!
      load_service_definition
      load_module_definition
      Logger.init_logging!
    end
  
    def config_path
      @config_path || "config/"
    end
    
    def config_path=(config_path)
      @config_path = config_path
    end
    
    def load_service_definition
      require File.join(config_path, "service_definition")
    end

    def load_module_definition
      require File.join(config_path, "module_definition")
    end
    
    def env
      @env || ENV["HOTH_ENV"] || (Object.const_defined?("Rails") ? Rails.env.to_sym : :development)
    end
    
    def env=(env)
      @env = env.to_sym
    end
    
  end
  
end