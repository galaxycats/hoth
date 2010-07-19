module Hoth
  class Logger
    class <<self

      def log_provider=(log_provider)
        @log_provider = log_provider
      end

      def init_logging!(logfile="log/hoth.log")
        Hoth::Logger.log_provider = if Object.const_defined?("Rails")
          Rails.logger
        else
          require 'logger'
          ::Logger.new(logfile)
        end
      end

      def debug(msg)
        log_provider.debug msg
      end

      def info(msg)
        log_provider.info msg
      end

      def warn(msg)
        log_provider.warn msg
      end

      def error(msg)
        log_provider.error msg
      end

      def fatal(msg)
        log_provider.fatal msg
      end

      def log_provider
        @log_provider || init_logging!
      end
    end
  end
end