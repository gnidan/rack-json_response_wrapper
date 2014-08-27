require 'rspec'
require 'rack/test'
require 'sinatra/base'

require File.join(File.dirname(__FILE__), '..', 'lib', 'rack', 'json_response_wrapper.rb')

RSpec.configure do |config|
  ENV['RACK_ENV'] ||= 'test'
end
