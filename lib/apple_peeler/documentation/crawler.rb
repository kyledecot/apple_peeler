# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

require 'apple_peeler/documentation/pool'
require 'apple_peeler/cache'

class ApplePeeler
  class Documentation
    class Crawler
      def initialize(host)
        @host = host
        @pool = Pool.new(size: 10)
        @semaphore = Mutex.new
        @cache = Cache.new
      end

      def enqueued_uris
        @enqueued_uris ||= Set.new
      end

      def visited_uris
        @visited_uris ||= Set.new
      end

      def start(path, &block)
        uri = URI.parse("#{@host}#{path}")

        schedule { load(uri, &block) }

        loop do
          sleep(5)

          break if @pool.jobs.size.zero?
        end

        @pool.shutdown
      end

      def enqueued?(uri)
        synchronize do
          enqueued_uris
            .map(&:path)
            .include?(uri.path)
        end
      end

      def visited?(uri)
        synchronize do
          visited_uris
            .map(&:path)
            .include?(uri.path)
        end
      end

      private

      def relevant_uris(document)
        document
          .xpath('//a/@href')
          .map(&:value)
          .select { |href| href.match?(%r{/documentation\/appstoreconnectapi}) }
          .map { |href| URI.parse("#{@host}#{href}") }
      end

      def schedule(&block)
        @pool.schedule(&block)
      end

      def synchronize(&block)
        @semaphore.synchronize(&block)
      end

      def load(uri, &block)
        enqueued_uris.delete(uri)
        visited_uris.add(uri)

        document = nil
        html = @cache[uri.to_s]

        if html.nil?
          html = URI.open(uri).read
          document = Nokogiri::HTML(html)
          @cache[uri.to_s] = html
        else
          document = Nokogiri::HTML(html)
        end

        yield document if block_given?

        relevant_uris(document).each do |relevant_uri|
          next if visited?(relevant_uri)
          next if enqueued?(relevant_uri)

          enqueued_uris.add(relevant_uri)

          schedule { load(relevant_uri, &block) }
        end
      end
    end
  end
end
