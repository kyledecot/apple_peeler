# frozen_string_literal: true

require 'nokogiri'

class ApplePeeler
  module Spec
    module Helpers
      def document_for(url:)
        VCR.use_cassette(url) { Nokogiri::HTML(open(url)) }
      end
    end
  end
end
