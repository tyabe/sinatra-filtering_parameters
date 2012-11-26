# Sinatra Filtering Parameters

- [Homepage](https://github.com/tyabe/sinatra-filtering_parameters#readme)
- [Issues](https://github.com/tyabe/sinatra-filtering_parameters/issues)
- [Documentation](http://rubydoc.info/gems/sinatra-filtering_parameters/frames)
- [Email](mailto:tyabe at nilidea.com)
- [Twitter](http://twitter.com/tyabe)

## Description

This plugin add parameter whitelisting to a Sinatra application.

## Examples

``` ruby
require 'sinatra/filtering_parameters'
class App < Sinatra::Base
  register Sinatra::FilteringParameters

  post '/create', :allow => [ :title, :body ] do
    @post = Post.new(params)
    # ...
  end
```

## Install

with RubyGems:

```
$ gem install sinatra-filtering_parameters

```
if using Bundler, add to your Gemfile:

```
gem "sinatra-filtering_parameters"
```
and run

```
$ bundle install
```

## Copyright

Copyright (c) 2012 Takeshi Yabe
See LICENSE.txt for details.

