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
          case filter
          when Symbol, String
            filter = filter.to_s
            next unless params.is_a?(Hash)

            if params.has_key?(filter)
              if params[filter].is_a?(Hash)
                allow_param = allow(params[filter], _filters)
                allow_params[filter] = allow_param unless allow_param.empty?
              else
                allow_params[filter] = params[filter]
              end
            end
          when Hash
            _params = {}
            filter.keys.map(&:to_s).each { |k| _params[k] = params[k] if params.has_key?(k) }
            _params.each do |key, value|
              case value
              when Array
                [value].flatten.each do |v|
                  allow_param = allow(v, filter.values)
                  unless allow_param.empty?
                    allow_params[key] ||= []
                    allow_params[key] << allow_param
                  end
                end
              else
                if value.keys.all? { |k| k =~ /\A-?\d+\z/ }
                  value.each do |k, v|
                    allow_param = allow(v, filter.values)
                    unless allow_param.empty?
                      allow_params[key] ||= {}
                      allow_params[key][k] = allow_param
                    end
                  end
                else
                  allow_param = allow(value, filter.values)
                  allow_params[key] = allow_param unless allow_param.empty?
                end
              end
            end
          end
        end
        allow_params
      end
    end
  end
end
