require 'singleton'

require 'active_support/inflector'

require 'hoth/transport/hoth_transport'
require 'hoth/transport/http_transport'
require 'hoth/transport/bert_transport'
require 'hoth/transport/workling_transport'

require 'hoth/service_definition'
require 'hoth/service_module'
require 'hoth/endpoint'
require 'hoth/service'
require 'hoth/service_deployment'
require 'hoth/service_registry'
require 'hoth/services'

require 'hoth/util/logger'

require 'hoth/extension/core/exception'
require 'hoth/exceptions'

Hoth::Logger.init_logging!