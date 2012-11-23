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
