# frozen_string_literal: true

require 'pry'

require 'apple_peeler/cache'

require 'concurrent/set'
require 'vessel'

class ApplePeeler
  class Documentation
    class Crawler < Vessel::Cargo
      domain 'developer.apple.com'
      start_urls 'https://developer.apple.com/documentation/appstoreconnectapi'

      private

      def enqueued_uris
        @enqueued_urls ||= Concurrent::Set.new
      end

      def parsed_uris
        @parsed_urls ||= Concurrent::Set.new
      end

      def relevant_url?(url)
        uri = URI(url)

        uri.path.start_with?('/documentation/appstoreconnectapi')
      end

      def relevant_uris(hash)
        hash['references']
          .select { |_, v| v.key?('url') && relevant_url?(v['url']) }
          .map { |_, v| URI.parse(absolute_url(v['url'])) }
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

      def parse
        uri = URI(page.url)
        enqueued_uris.delete(uri)
        parsed_uris << uri
        # @limit += 1
        # enqueued_uris.delete(uri)
        # visited_uris.add(uri)
        # puts "we are in load"

        # begin
        # current_page.goto(uri)
        wait_for_relevant(network_traffic: page.network.traffic)
        # rescue Ferrum::StatusError, Ferrum::BrowserError
        # puts "[  ERROR   ] #{uri.to_s.red}"
        # return
        # end
        #
        # puts "SOMEHOW WE ARE STILL HERE" if @a
        # begin
        raw_hash = JSON.parse(json_for(page))
        # rescue  Exception => e
        # puts "[WE RESCUED AN EXCEPTION] #{uri}".red
        # raise e
        # end
        # yield uri, raw_hash if block_given?
        #
        #
        #

        relevant_uris(raw_hash).each do |relevant_uri|
          next if enqueued_uris.include?(relevant_uri)
          next if parsed_uris.include?(relevant_uri)

          enqueued_uris << relevant_uri
          yield request(url: relevant_uri.to_s, method: :parse)

          puts "[ ENQUEUED ] #{relevant_uri.to_s.yellow}"
        end
      end
    end
  end
end
