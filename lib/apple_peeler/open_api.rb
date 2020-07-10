# frozen_string_literal: true

require 'yaml'
require 'active_support/core_ext/string/strip'
require 'apple_peeler/open_api/utils'
require 'apple_peeler/open_api/component'

class ApplePeeler
  class OpenAPI
    def initialize(documentation)
      @documentation = documentation

      @api = {}.tap do |api|
        api['openapi'] = '3.0.0'
        api['servers'] = servers
        # api['externalDocs'] = {
        # 'url' => '' # TODO
        # }
        # api['servers'] << {
        # 'url' => 'https://api.appstoreconnect.apple.com/v1'
        # }
        # api['paths'] ||= {}

        # api['paths'] = Utils.paths(documentation_by_type[:web_service_endpoint])
        #
        api['components'] = components
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

    private

    def components
      {
        'schemas' => {}
      }
      # {
      # "schemas" => @documentation.documentation_by_type[:object].map do |documentation|
      # [documentation.type, Component.new(documentation).to_h]
      # api['components']['schemas'][documentation.type] = {
      # 'type' => 'object' # TODO: this isn't always a object!
      # }
      # api['components']['schemas'][documentation.type]['properties'] = documentation.properties.map do |property|
      # if property.required?
      # api['components']['schemas'][documentation.type]['required'] ||= []
      # api['components']['schemas'][documentation.type]['required'] << property.name
      # end
      # [property.name, {}]
      # end.to_h
      # }
    end

    def servers
      []
    end
  end
end
