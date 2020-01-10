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
        enqueued_uris.map(&:path).include?(uri.path)
      end

      def visited?(path)
        paths.include?(path)
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
        synchronize do 
          enqueued_uris.delete(uri)
          paths.add(uri.path)
        end 

        document = nil
        html = @cache[uri.to_s]

        unless html.nil?
          document = Nokogiri::HTML(html)
        else
          html = URI.open(uri).read
          document = Nokogiri::HTML(html)
          @cache[uri.to_s] = html
        end 

        yield document if block_given?

        relevant_uris(document).each do |relevant_uri|
          next if visited?(relevant_uri.path)
          next if enqueued?(relevant_uri)
          
          synchronize do 
            enqueued_uris.add(relevant_uri) 
          end 

          schedule { load(relevant_uri, &block) }
        end
      end

      def enqueued_uris
        @enqueued_uris ||= Set.new
      end

      def paths
        @paths ||= Set.new
      end
    end
  end
end
