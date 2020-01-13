# frozen_string_literal: true

require 'nokogiri'

class ApplePeeler
  module Spec
    module Helpers
      def document(http_method, path)
        relative_path = File.join('spec', 'support', 'fixtures', http_method.to_s, path)
        absolute_path = File.expand_path(relative_path)

        Nokogiri::HTML(File.read(absolute_path))
      end
    end
  end
end
