# frozen_string_literal: true

require 'terminal-table'
require 'colorize'

require 'apple_peeler/documentation/object/property'

class ApplePeeler
  class Documentation
    class Object
      TYPE = :object

      def self.parsable?(document)
        title = document.css('.topic-title .eyebrow')&.text.to_s

        title == 'Object'
      end

      def initialize(document:)
        @document = document
      end

      def identifier
        Digest::MD5.new.<<(['object', name].join('')).hexdigest
      end

      def inspect
        "#<ApplePeeler::Documentation::Object identifier=\"#{identifier}\">"
      end

      def type
        @type ||= document
                  .at('.topic-heading')
                  .text
      end

      def self.type
        :object
      end

      def to_terminal_table
        @to_terminal_table ||= begin
          Terminal::Table.new do |table|
            table.title = "Object\n#{name.green}"
            table.headings = %w[name type required array]
            table.rows = properties.map do |parameter|
              [
                parameter.name,
                parameter.type,
                parameter.required?,
                parameter.array?
              ]
            end
          end
        end
      end

      def property_names
        @property_names ||= document
                            .css('#properties .parametertable-name')
                            .map(&:text)
      end

      def property_types
        @property_types ||= document
                            .css('#properties .parametertable-type')
                            .map { |e| e.text.gsub(/\W+/, '') }
      end

      def properties
        @properties ||= begin
          @document.css('.parametertable-row').map do |element|
            Property.new(element: element)
          end
        end
      end

      def dependencies
        property_types
      end

      private

      attr_reader :document
    end
  end
end
