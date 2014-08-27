require "bundler/gem_tasks"
require "bundler/setup"

task default: [:spec]

desc 'run rspec specs'
task :spec do
  ENV['RACK_ENV'] ||= 'test'
  sh 'rspec'
end
