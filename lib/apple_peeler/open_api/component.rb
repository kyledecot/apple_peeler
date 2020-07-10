require 'yaml'

require 'apple_peeler/open_api/property'

class ApplePeeler
  class OpenAPI
    class Component
      def initialize(documentation)
        @documentation = documentation
        @required = []
      end 

      def to_h 
        { 
          'type' => type,
          'properties' => properties,
          'required' => required
        }
      end 

      private 

      attr_reader :required
  
      def type 
        # require 'pry'
        # binding.pry
        # if PRIMITIVES.include?(@documentation.type)
          # @documentation.type
        # else
          "object"
        # end
      end 

      def properties
        @documentation.properties.map do |property|
          required << property.name if property.required?
          [property.name, Property.new(property).to_h]
        end.to_h
      end 
    end
  end
end
