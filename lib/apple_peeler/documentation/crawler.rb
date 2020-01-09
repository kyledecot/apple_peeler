# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

require 'apple_peeler/documentation/pool'

class ApplePeeler
  class Documentation
    class Crawler
      def initialize(host)
        @host = host
        @pool = Pool.new(size: 5)
        @semaphore = Mutex.new
        @count = 0
      end

      def start(path, &block)
        uri = URI.parse("#{@host}#{path}")

        load(uri, &block)

        loop do
          sleep(5)

          break if @pool.jobs.size.zero?
        end

        @pool.shutdown
      end

      def enqueued?(uri)
        enqueued_uris.map(&:path).include?(uri.path)
      end

      def visited?(uri)
        paths.include?(uri.path)
      end

      private

      def relevant_uris(document)
        document
          .xpath('//a/@href')
          .map(&:value)
          .select { |href| href.match?(%r{/documentation\/appstoreconnectapi}) }
          .map { |href| URI.parse("#{@host}#{href}") }
      end

      def load(uri, &block)
        @pool.schedule do
          unless visited?(uri) || enqueued?(uri)
            document = nil
            VCR.use_cassette(uri.to_s, record: :once, match_requests_on: %i[method uri]) do
              document = Nokogiri::HTML(URI.open(uri))
            end
            @semaphore.synchronize { @count += 1; }
            @semaphore.synchronize { uris << uri }

            yield document if block_given?

            relevant_uris(document).each do |relevant_uri|
              load(relevant_uri, &block)
            end
          end
        end
      end

      def enqueued_uris
        @enqueued_uris ||= Set.new
      end

      def uris
        @uris ||= Set.new
      end

      def paths
        uris.map(&:path).to_set
      end
    end
  end
end
