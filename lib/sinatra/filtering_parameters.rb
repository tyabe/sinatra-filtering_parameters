require 'sinatra/filtering_parameters/version'

module Sinatra
  module FilteringParameters
    class << self
      def registered(app)
        app.set(:allow) do |*filters|
          condition do
            _params = params.dup
            params.clear
            %w[ splat captures ].each do |name|
              params[name] = _params.delete(name)
            end
            hoge = Sinatra::FilteringParameters.allow(_params, filters)
            params.merge! hoge
          end
        end
      end

      def allow(params, filters)
        allow_params = {}
        _filters = [filters].flatten
        [filters].flatten.each do |filter|
          _filters.shift
          filter = filter.to_s
          if params.has_key?(filter)
            if params[filter].is_a?(Hash)
              allow_params[filter] = allow(params[filter], _filters)
            else
              allow_params[filter] = params[filter]
            end
          end
        end
        allow_params
      end
    end
  end
end
