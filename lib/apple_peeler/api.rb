# frozen_string_literal: true

require 'yaml'

class ApplePeeler
  class API
    def initialize(documentation_by_type)
      @api = {}.tap do |api|
        api['openapi'] = '3.0.0'
        api['servers'] ||= []
        api['servers'] << {
          'url' => 'https://api.appstoreconnect.apple.com/v1'
        }
        api['paths'] ||= {}

        documentation_by_type[:web_service_endpoint].each do |documentation|
          api['paths'][documentation.path] ||= {}
          api['paths'][documentation.path][documentation.http_method.downcase] = {}
          api['paths'][documentation.path][documentation.http_method.downcase]['responses'] = {}
        end

        api['components'] ||= {}
        api['components']['schemas'] ||= {}
        documentation_by_type[:object].each do |documentation|
          api['components']['schemas'][documentation.type] = {
            'type' => 'object'
          }
          api['components']['schemas'][documentation.type]['properties'] = documentation.properties.map do |property|
            if property.required?
              api['components']['schemas'][documentation.type]['required'] ||= []
              api['components']['schemas'][documentation.type]['required'] << property.name
            end
            [property.name, {}]
          end.to_h
        end
      end
    end

    def component_schema(documentation)
      {
        'type' => 'object',
        'properties' => documentation.properties.map do |property|
          [property.name, {}]
        end.to_h
      }
    end

    def to_json(*_args)
      @api.to_json
    end

    def to_yaml(**options)
      @api.to_yaml(options)
    end
  end
end
