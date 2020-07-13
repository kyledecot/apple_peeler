# frozen_string_literal: true

class ApplePeeler
  class Documentation
    class Object
      class Property
        TYPE = :object_property

        def self.for(document:)
          document
            .css('.parametertable-row')
            .detect { |_| true } # TODO: Implement this
        end

        def initialize(element:)
          @element = element
        end

        def name
          @element.at('.parametertable-name').text.gsub(/(\[|\])/, '')
        end

        def type
          @element.at('.parametertable-type').text.chomp("\n").gsub(/(\[|\])/, '')
        end

        def array?
          !@element.at('.parametertable-type').text.match(/\[.+\]/).nil?
        end

        def required?
          @element
            .at('.parametertable-requirement')
            &.text
            &.match?(/Required/)
        end
      end
    end
  end
end
