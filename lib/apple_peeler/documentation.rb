# frozen_string_literal: true

require 'apple_peeler/documentation/object'
require 'apple_peeler/documentation/type'
require 'apple_peeler/documentation/web_service_endpoint'
require 'apple_peeler/documentation/crawler'
require 'apple_peeler/graph'
require 'yaml'

class ApplePeeler
  class Documentation
    attr_reader :documentation

    def self.types
      @types ||= []
    end

    def self.register(klass)
      types << klass
    end

    def initialize(on_documentation: nil)
      @on_documentation = on_documentation
      @documentation = []
      @components = {
        schemas: {}
      }
    end

    def load!
      Crawler.run do
        puts "[   DONE   ] #{uri.to_s.green}"
        documentation = to_documentation(raw_hash)

        if documentation
          @documentation << documentation
          @on_documentation&.call(documentation)
          puts "[DOCUMENTED] #{uri}".cyan
        else
          puts "[   UNKNOWN   ] #{uri}".blue
        end
      end

      true
    end

    def to_graph
      Graph.new(self)
    end

    private

    def to_documentation(raw_hash)
      self.class.types.find do |type|
        next unless type.parsable?(raw_hash)

        break type.new(raw_hash)
      end
    end
  end
end
