# frozen_string_literal: true

class ApplePeeler
  class Documentation
    class Object
      class Property
        TYPE = :object_property

        def self.for(document:, name:)
          require 'pry'
          binding.pry
          document
            .css('.parametertable-row')
            .detect { |e| require 'pry'; binding.pry; true }
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
