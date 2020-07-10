require 'forwardable'

class ApplePeeler
  class OpenAPI
    class Property
      extend Forwardable

      PRIMITIVES = %w[string].freeze

      def_delegator :@documentation, :array?

      def initialize(documentation)
        @documentation = documentation
      end 

      def to_h 
        {}.tap do |hash|
          hash['type'] = top_level_type
          hash['items'] = items if array?

          unless PRIMITIVES.include?(@documentation.type)
            hash['$ref'] = "#/components/schemas/#{@documentation.type}"
          end 
        end 
      end 

      private 

      def top_level_type
        array? ? 'array' : type
      end 

      def items 
        {
          type: type
        } 
      end 
  
      def type 
        if PRIMITIVES.include?(@documentation.type)
          @documentation.type
        else 
          "object"
        end
      end 
    end
  end
end
