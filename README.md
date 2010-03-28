# hoth

Creating a SOA requires a centralized location to define all services within the SOA. Furthermore you want to know where those services live.

# How to use

## Install

    gem install hoth

## Define services and modules

### service-definition

This is how you define services:

    Hoth::Services.define do
  
      service :service_name do |first_param, second_param|
        returns :descriptive_name
      end
        
    end

This definition describes a service with a name, some parameters and its return value. The naming of the parameters is just for your understanding and will never be used again, so be descriptive. Same goes for the return value. The only exception is, if you want to assure that a service returns nil you can write
  
    returns :nothing
    
A service whith this return value will always return nil.

### module-definition

After defining all you services, you need to specify in which modules they live. Each module can be seen as a set of implemented services. Each module can have one or more endpoints. Here is how you define these modules with its endpoints and services:


    Hoth::ServiceModules.define do

      service_module :module_name do
        env :development, :test do
          endpoint :default,
            :host => 'localhost',
            :port => 3000,
            :transport_type => :http

          endpoint :bert,
            :host => 'localhost',
            :port => 9999,
            :transport_type => :bert

        end

        env :production do
          endpoint :default,
            :host => '192.168.1.12',
            :port => 3000,
            :transport_type => :http

          endpoint :bert,
            :host => '192.168.1.15',
            :port => 9999,
            :transport_type => :bert

        end
    
        add_service :first_service
        add_service :second_service, :via => :bert
      end
      
    end


As you can see, it is possible to define different endpoints for different environments. Each endpoint has a host, a port and a transport-type. After defining your endpoints you can add your previously defined services to the module and define which endpoint they should use. If you do not specify an endpoint the :default endpoint will be used.

## Integrate in your project

### Rails 

Just add the definitions from above to your initializers, for example in these two files:

  * initializers/service_definition.rb
  * initializers/module_definition.rb

### Other

Add the definitions from above to your code, so that they are executed at startup. It is very important, that the service-definitions get loaded BEFORE the module-definitions are included.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009-2010 Dirk Breuer. See LICENSE for details.
