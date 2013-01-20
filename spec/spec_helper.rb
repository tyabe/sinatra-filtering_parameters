gem 'rspec', '~> 2.4'
require 'rspec'
require 'rack/test'

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/filtering_parameters'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Sinatra::TestHelpers
end

def mock_route(path, opts={}, &block)
  mock_app do
    register Sinatra::FilteringParameters
    %w(get post put delete head options patch).each do |verb|
      send(verb.to_sym, path, opts, &block)
    end
  end
end

