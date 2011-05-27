require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "hoth"
    gem.summary = %Q{Registry and deployment description abstraction for SOA-Services}
    gem.description = <<-DESCRIPTION
Creating a SOA requires a centralized location to define all services within the
SOA. Furthermore you want to know where to deploy those services.
DESCRIPTION
    gem.email = "dirk.breuer@gmail.com"
    gem.homepage = "http://github.com/galaxycats/hoth"
    gem.authors = ["Dirk Breuer"]
    gem.files = FileList["[A-Z]*.*", "{lib,spec}/**/*"]

    gem.add_dependency "activesupport"
    gem.add_dependency "bertrpc"
    gem.add_dependency "json"
    
    gem.add_development_dependency "rspec", "~> 2.6.0"
    gem.add_development_dependency "simple_publisher"
    gem.add_development_dependency "beanstalk-client"
    gem.add_development_dependency "em-jack"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Jeweler::RubygemsDotOrgTasks.new

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "hoth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
