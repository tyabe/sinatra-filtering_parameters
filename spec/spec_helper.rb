gem 'rspec', '~> 2.4'
require 'rspec'
require 'rack/test'

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/filtering_parameters'
require 'json'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Sinatra::TestHelpers
end

def result_should_be_equal(filterd_params)
  last_response.body.should == filterd_params.to_json
end

def mock_route(path, opts={}, &block)
  mock_app do
    register Sinatra::FilteringParameters
    %w(get post put delete head options patch).each do |verb|
      send(verb.to_sym, path, opts, &block)
    end
  end
end

