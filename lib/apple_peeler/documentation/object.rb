# frozen_string_literal: true

require 'terminal-table'
require 'colorize'
require 'apple_peeler/open_api/component'

require 'apple_peeler/documentation/object/property'

class ApplePeeler
  class Documentation
    class Object
      TYPE = :object

      PRIMITIVES = %w[integer urireference string email datetime boolean].freeze

      def self.parsable?(raw_hash)
        true # TODO
        # title = document.css('.topic-title .eyebrow')&.text.to_s
#
        # title == 'Object'
      end

      def initialize(raw_hash)
        @raw = raw_hash
      end

      def identifier
        type
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

      def to_component
        OpenAPI::Component.new(self)
      end 

      def property_names
        @property_names ||= document
                            .css('#properties .parametertable-name')
                            .map(&:text)
      end

      def property_types(primitive = true)
        @property_types ||= begin
          non_polymorphic_types = document
                                  .css('#properties .parametertable-type')
                                  .map { |e| e.text.gsub(/[^a-zA-Z\.]/, '') }
                                  .select { |t| t != '' && (primitive || !PRIMITIVES.include?(t)) }
                                  .compact

          # TODO: I Don't think that primitives can show up here however
          # we should make sure that is indeed the case
          polymorphic_types = document
                              .css('#properties .parametertable-metadata .possibletypes .symbolref')
                              .map(&:text)

          polymorphic_types + non_polymorphic_types
        end

        @property_types
      end

      def properties
        @properties ||= begin
          @document.css('.parametertable-row').map do |element|
            Property.new(element: element)
          end
        end
      end

      def dependencies
        property_types(false)
      end

      private

      attr_reader :document
    end
  end
end
