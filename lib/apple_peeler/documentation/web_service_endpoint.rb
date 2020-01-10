# frozen_string_literal: true

require 'terminal-table'
require 'colorize'

class ApplePeeler
  class Documentation
    class WebServiceEndpoint
      TYPE = :web_service_endpoint

      def self.parsable?(document)
        title = document.css('.topic-title .eyebrow')&.text.to_s

        title == 'Web Service Endpoint'
      end

      def initialize(document:)
        @document = document
      end

      def url
        "#{host}#{path}"
      end

      def host
        @document.at('.endpointurl-host').text
      end

      def self.type
        :web_service_endpoint
      end

      def name
        "web-service-endpoint-#{SecureRandom.hex}"
      end

      def heading
        @heading ||= @document.css('.topic-title .topic-heading')&.text.to_s
      end

      def type
        :web_service_endpoint
      end

      def path
        @document.at('.endpointurl-path').text
      end

      def http_method
        @document.at('.endpointurl-method').text.downcase.to_sym
      end

      def http_body
        # @http_body ||= HTTPBody.new
      end

      def description
        @description ||= @document.at('.topic-description').text
      end

      def response_codes
        @document.search('#response-codes .parametertable-row').map do |element|
          {
            status_code: response_code_status_code(element),
            status_phrase: response_code_status_reason_phrase(element),
            type: response_code_status_type(element)
          }
        end
      end

      def to_terminal_table
        @to_terminal_table ||= begin
          Terminal::Table.new do |table|
            table.title = "Web Service Endpoint\n\n#{http_method}\n#{url.light_blue}\n\n#{description}"
            table.headings = %w[Code Phrase Type]
            table.rows = response_codes.map do |response_code|
              [
                response_code[:status_code],
                response_code[:status_phrase],
                response_code[:type]
              ]
            end
          end
        end
      end

      private

      def response_code_status_type(element)
        element.at('.parametertable-type')&.text&.chomp
      end

      def response_code_status_reason_phrase(element)
        element.at('.parametertable-status .parametertable-status-reasonphrase').text.chomp
      end

      def response_code_status_code(element)
        status = element.at('.parametertable-status').text.chomp

        status.gsub(" #{response_code_status_reason_phrase(element)}", '')
      end
    end
  end
end
