# -*- encoding: utf-8 -*-

require File.expand_path('../lib/sinatra/filtering_parameters/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "sinatra-filtering_parameters"
  gem.version       = Sinatra::FilteringParameters::VERSION
  gem.summary       = "Filtering allowed parameters for Sinatra"
  gem.description   = "This adds filter to use only those parameters that are allowed to a Sinatra application."
  gem.license       = "MIT"
  gem.authors       = ["Takeshi Yabe"]
  gem.email         = "tyabe@nilidea.com"
  gem.homepage      = "https://github.com/tyabe/sinatra-filtering_parameters#readme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency "sinatra",   "~> 1.3"

  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency "rack-test"
end
