module Hoth
  class DeploymentModule

    class Environment
      attr_accessor :endpoint, :mongrel_start_port, :mongrel_servers
      
      def initialize(attributes)
        @endpoint           = attributes[:endpoint]
        @mongrel_start_port = attributes[:mongrel_start_port]
        @mongrel_servers    = attributes[:mongrel_servers]
      end
    end
    
    def initialize
      @environments = {}
    end
    
    def env(env_name, options)
      @environments[env_name] = Environment.new(options)
    end
    
    def [](env_name)
      @environments[env_name]
    end
    
    def path(path)
      @path = path
    end

  end
end