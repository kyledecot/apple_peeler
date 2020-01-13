# frozen_string_literal: true

require 'apple_peeler/documentation/object'
require 'apple_peeler/documentation/type'
require 'apple_peeler/documentation/web_service_endpoint'
require 'apple_peeler/documentation/crawler'
require 'apple_peeler/graph'

class ApplePeeler
  class Documentation
    attr_reader :documentation_by_type

    def self.types
      @types ||= []
    end

    def self.register(klass)
      types << klass
    end

    def to_json(*_args)
      {} # TODO
    end

    def initialize(on_documentation: nil)
      @documentation_by_type = Hash.new { |h, k| h[k] = [] }
      @on_documentation = on_documentation
      @crawler = Crawler.new('https://developer.apple.com')
    end

    def load!
      @crawler.start('/documentation/appstoreconnectapi') do |document|
        documentation = to_documentation(document)

        unless documentation.nil?
          @documentation_by_type[documentation.class::TYPE] << documentation
          @on_documentation&.call(documentation)
        end
      end

      true
    end

    def to_graph
      Graph.new(self)
    end

    private

    def to_documentation(document)
      self.class.types.find do |type|
        next unless type.parsable?(document)

        break type.new(document: document)
      end
    end
  end
end
