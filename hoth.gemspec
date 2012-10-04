# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hoth/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "hoth"
  gem.version       = Hoth::VERSION

  gem.authors       = ["Dirk Breuer"]
  gem.email         = ["dirk.breuer@gmail.com"]
  gem.description   = <<-DESC.strip
Creating a SOA requires a centralized location to define all services within the
SOA. Furthermore you want to know where to deploy those services.
  DESC
  gem.summary       = %q{Registry and deployment description abstraction for SOA-Services}
  gem.homepage      = "https://github.com/galaxycats/hoth"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "hoth", ">= 0"
  gem.add_runtime_dependency "activesupport"
  gem.add_runtime_dependency "json", ">= 0"
  gem.add_runtime_dependency "rack"

  gem.add_development_dependency "rspec", "~> 2.11"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "em-jack"
  gem.add_development_dependency "beanstalk-client"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "redcarpet"
end
