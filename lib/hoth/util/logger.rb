module Hoth
  class Logger
    class <<self
      
      def log_provider=(log_provider)
        @@logger = log_provider
      end
      
      def init_logging!
        Hoth::Logger.log_provider = if Object.const_defined?("Rails")
          Rails.logger
        else
          require 'logger'
          ::Logger.new("/tmp/hoth.log")
        end
      end
      
      def debug(msg)
        @@logger.debug msg
      end
      
      def info(msg)
        @@logger.info msg
      end
      
      def warn(msg)
        @@logger.warn msg
      end
      
      def error(msg)
        @@logger.error msg
      end
      
      def fatal(msg)
        @@logger.fatal msg
      end
    end
        
  end
end