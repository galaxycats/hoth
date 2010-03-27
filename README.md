# hoth

Creating a SOA requires a centralized location to define all services within the SOA. Furthermore you want to know where those services live.

# How to use

## Install

    gem install hoth

## Define services and modules

### service-definition

    Hoth::Services.define do
  
      service :increment_statistics do |statistic_objects, event|
        returns :nothing
      end
  
      service :statistic_of_cars do |ids|
        returns :statistic_datas
      end
  
      service :create_account do |account|
        returns :account_ids
      end
  
    end

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
