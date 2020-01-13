# frozen_string_literal: true

require 'terminal-table'
require 'colorize'

class ApplePeeler
  class Documentation
    class Type
      TYPE = :type

      def self.parsable?(document)
        title = document.css('.topic-title .eyebrow')&.text.to_s

        title == 'Type'
      end

      def initialize(document:)
        @document = document
      end

      def identifier
        type
      end

      def self.type
        :type
      end

      def type
        @document.css('.topic-heading').text
      end

      def possible_values
        @document
          .css('#possible-values .datalist-term')
          .map(&:text)
      end

      def inspect
        "#<ApplePeeler::Documentation::Type identifier=\"#{identifier}\">"
      end

      def dependencies
        []
      end

      def to_terminal_table
        Terminal::Table.new do |table|
          table.title = "Type\n#{name.yellow}"
          table.headings = ['type', 'possible values']
          table.rows = []
        end
      end
    end
  end
end
