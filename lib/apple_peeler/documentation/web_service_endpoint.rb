# frozen_string_literal: true

require 'terminal-table'
require 'colorize'
require 'digest'

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
        @url ||= "#{host}#{path}"
      end

      def host
        @host ||= @document
                  .at('.endpointurl-host')
                  .text
      end

      def identifier
        "#{http_method} #{path}"
      end

      def inspect
        "#<ApplePeeler::Documentation::WebServiceEndpoint identifier=\"#{identifier}\">"
      end

      def heading
        @heading ||= @document.css('.topic-title .topic-heading')&.text.to_s
      end

      def path
        @document.at('.endpointurl-path').text
      end

      def http_method
        @document.at('.endpointurl-method').text
      end

      def http_body_type(primitive = true)
        element = @document.at('#http-body .parametertable-type')

        return if element.nil?
        return if element.text.chomp == 'binary' && primitive == false

        element.text.chomp
      end

      def description
        @description ||= @document.at('.topic-description').text
      end

      def response_codes
        @response_codes ||= begin
                              @document.search('#response-codes .parametertable-row').map do |element|
                                {
                                  status_code: response_code_status_code(element),
                                  status_phrase: response_code_status_reason_phrase(element),
                                  type: response_code_status_type(element)
                                }
                              end
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

      def dependencies
        @dependencies ||= [http_body_type(false)].compact + response_types
      end

      private

      def response_types
        @response_types ||= response_codes
                            .map { |rc| rc[:type] }
                            .compact
                            .uniq
      end

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
