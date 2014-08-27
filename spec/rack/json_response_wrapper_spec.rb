require 'json'
require_relative '../spec_helper'

describe Rack::JsonResponseWrapper do
  include Rack::Test::Methods

  class MockedApp < Sinatra::Base
    post '/' do
      content_type 'application/json'
      JSON.dump(JSON.parse(request.body.read))
    end

    post '/html' do
      content_type 'text/html'
      JSON.dump(JSON.parse(request.body.read))
    end
  end

  def app
    @app ||= Rack::JsonResponseWrapper.new(MockedApp)
  end

  describe 'call' do
    before do
      @obj = { foo: true, bar: 1, baz: 'hoagie' }
      @json = JSON.dump(@obj)
    end

    it 'does nothing to the response if X-WRAP-RESPONSE is not defined' do
      post '/', @json

      expect(last_response.body).to eq @json
    end

    it 'does nothing to the response if Content-Type is not json, even with X-WRAP-RESPONSE' do
      post '/html', @json, 'X-WRAP-RESPONSE' => true
      
      expect(last_response.body).to eq @json
    end

    it 'wraps the response if X-WRAP-RESPONSE is set' do
      post '/', @json, 'X-WRAP-RESPONSE' => true

      @response_obj = JSON.parse(last_response.body)

      expect(@response_obj).to include 'header'
      expect(@response_obj).to include 'body'


      expect(JSON.dump(@response_obj['body'])).to eq @json
    end

    it 'when wrapping, includes response header in body' do
      post '/', @json, 'X-WRAP-RESPONSE' => true

      @response_obj = JSON.parse(last_response.body)
      @response_header = last_response.header

      @response_wrapped_header = @response_obj['header']

      expect(JSON.dump(@response_wrapped_header)).to eq JSON.dump(@response_header)
    end
  end
end
