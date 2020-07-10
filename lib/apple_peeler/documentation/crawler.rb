# frozen_string_literal: true

        require 'pry'
require 'open-uri'
require 'nokogiri'

require 'apple_peeler/documentation/pool'
require 'apple_peeler/cache'

class ApplePeeler
  class Documentation
    class Crawler
      attr_reader :pool

      def initialize(host)
        @host = host
        @pool = Pool.new(size: 1)
        @semaphore = Mutex.new
        @cache = Cache.new
        @limit = -1
      end

      def enqueued_uris
        @enqueued_uris ||= Set.new
      end

      def visited_uris
        @visited_uris ||= Set.new
      end

      def start(path, &block)
        uri = URI.parse("#{@host}#{path}")

        pool.open do
          schedule do |current_page| 
            load(current_page, uri, &block)
          end 
        end
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

      def relevant_url?(url)
        URI(url).relative?
      end 

      def relevant_uris(hash)
        hash["references"]
          .select { |_, v| v.key?("url") && relevant_url?(v["url"]) }
          .map { |_, v| URI.parse("#{@host}#{v["url"]}")}
      end

      def schedule(&block)
        @pool.schedule(&block)
      end

      def synchronize(&block)
        @semaphore.synchronize(&block)
      end

      def json_for(page)
        relevant(network_traffic: page.network.traffic)
          .map { |e| e.response.body }
          .last # TODO: Is the ordering safe/predictable
      end 

      def relevant(network_traffic:)
        network_traffic
          .select { |e| e.request.url.end_with? '.json' } # TODO: This is naieve
      end 

      def wait_for_relevant(network_traffic:)
        relevant_network_traffic = relevant(network_traffic: network_traffic)
          
        loop do 
          break if relevant_network_traffic.all?(&:finished?)

          sleep 1
        end 

        raise "One of the relavant files didn't load!!!! OH GOD." if relevant_network_traffic.any?(&:error)

        true
      end 

      def load(current_page, uri, &block)
        @limit += 1

        enqueued_uris.delete(uri)
        visited_uris.add(uri)

        # html = @cache[uri.to_s]

        # if html.nil?
          # @cache[uri.to_s] = hash
        # else
      # document = JSON.parse()Nokogiri::HTML(html)
        # end
        begin 
          current_page.goto(uri)
          wait_for_relevant(network_traffic: current_page.network.traffic)
        rescue Ferrum::StatusError, Ferrum::BrowserError
          puts "[  ERROR   ] #{uri.to_s.red}"
          return
        end 

        puts "SOMEHOW WE ARE STILL HERE" if @a 
      begin 
        raw_hash = JSON.parse(json_for(current_page))
      rescue  Exception => e
        puts "[WE RESCUED AN EXCEPTION] #{uri}".red
        raise e
      end

        yield uri, raw_hash if block_given?

        relevant_uris(raw_hash).each do |relevant_uri|
          next if visited?(relevant_uri)
          next if enqueued?(relevant_uri)
          next if @limit >= 10

          puts "[ ENQUEUED ] #{relevant_uri.to_s.yellow}"

          enqueued_uris.add(relevant_uri)

          schedule do |next_page| 
            load(next_page, relevant_uri, &block)
          end 
        end
      end
    end
  end
end
