# frozen_string_literal: true

require 'nokogiri'
require 'net/http'

class ApplePeeler
  module Spec
    module Helpers
      def document_for(url:)
        VCR.use_cassette(url) do
          response = Net::HTTP.get_response(URI(url))
          Nokogiri::HTML(response.body)
        end
      end
    end
  end
end
