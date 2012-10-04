#!/usr/bin/env rake

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'hoth/version'
require 'yard'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "Hoth #{Hoth::VERSION} Documentation"]
end
