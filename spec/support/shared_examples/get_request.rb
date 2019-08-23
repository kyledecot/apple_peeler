# frozen_string_literal: true

RSpec.shared_examples :get_request do |path:, query_params: nil|
  it do
    uri = "https://api.appstoreconnect.apple.com/v1/#{path}"

    if query_params
      uri += '?'

      uri += query_params.map { |k, v| "#{k}=#{v}" }.join('&')
    end

    expect(WebMock).to have_requested(:get, uri)
  end
end
