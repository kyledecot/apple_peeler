# frozen_string_literal: true

require 'terminal-table'
require 'colorize'

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

      def type
        :object
      end

      def self.type
        :object
      end

      def name
        @name ||= @document.at('.topic-heading').text
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

      def properties
        @properties ||= begin
          []
          # @document.css('.parametertable-row').map do |element|
          # Property.new(element: element)
          # end
        end
      end
    end
  end
end
