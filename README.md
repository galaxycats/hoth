# Hoth

Creating a SOA requires a centralized location to define all services within the SOA. Furthermore you want to know where those services live.

# How to use

## Install

    gem install hoth

## Define services and modules

### Service-Definition

This is how you define services:

    Hoth::Services.define do

      service :service_name do |first_param, second_param|
        returns :descriptive_name
      end

    end

This definition describes a service with a name, some parameters and its return value. The naming of the parameters is just for your understanding and will never be used again, so be descriptive. Same goes for the return value. The only exception is, if you want to assure that a service returns nil you can write

    returns :nothing

A service whith this return value will always return nil. You can also specify `:nil`, with the same result.

### Module-Definition

After defining all you services, you need to specify in which modules they live. Each module can be seen as a set of implemented services. Each module can have one or more endpoints. Here is how you define these modules with its endpoints and services:


    Hoth::Modules.define do

      service_module :module_name do
        env :development, :test do
          endpoint :default do
            host 'localhost'
            port 3000
            transport :http
          end

        end

        env :production do
          endpoint :default do
            host '192.168.1.12'
            port 3000
            transport :http
          end

          endpoint :beanstalk do
            host '192.168.1.15'
            port 11300
            transport :beanstalkd
          end
        end

        add_service :first_service
        add_service :second_service, :via => :beanstalk
      end

    end


As you can see, it is possible to define different endpoints for different environments. Each endpoint has a host, a port and a transport-type. After defining your endpoints you can add your previously defined services to the module and define which endpoint they should use. If you do not specify an endpoint the :default endpoint will be used.

## Integrate in your project

Just execute current code (in rails you can add this line to an initializer):

    Hoth.init!

By default, Hoth looks for the files service_definition and module_definition in the config-Directory (`./config`). If you need to load these files from another place, just set `Hoth.config_path` to your needs.

## Todo

  * Make the rack provider independent from one specific transport.
  * Make the bodies of the `rack_provider` return an object which responds to each in order not break on Ruby 1.9.

## Note on Patches/Pull Requests

  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a future version unintentionally.
  * Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
  * Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009-2010 Dirk Breuer. See LICENSE for details.
