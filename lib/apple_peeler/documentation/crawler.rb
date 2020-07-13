# frozen_string_literal: true

require 'pry'
require 'concurrent/set'
require 'vessel'

require 'apple_peeler/cache'

class ApplePeeler
  class Documentation
    class Crawler < Vessel::Cargo
      domain 'developer.apple.com'
      start_urls 'https://developer.apple.com/documentation/appstoreconnectapi'

      def self.enqueued_uris
        @enqueued_uris ||= Concurrent::Set.new
      end

      private_class_method :enqueued_uris

      def self.parsed_uris
        @parsed_uris ||= Concurrent::Set.new
      end

      private_class_method :parsed_uris

      private

      def parsed_uris
        self.class.parsed_uris
      end

      def enqueued_uris
        self.class.enqueued_uris
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
        self.class.enqueued_uris.delete(uri)
        self.class.parsed_uris << uri
        wait_for_relevant(network_traffic: page.network.traffic)
        raw_hash = JSON.parse(json_for(page))

        yield uri, raw_hash

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
