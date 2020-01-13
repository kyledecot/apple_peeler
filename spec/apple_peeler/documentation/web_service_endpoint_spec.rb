# frozen_string_literal: true

RSpec.describe ApplePeeler::Documentation::WebServiceEndpoint do
  describe '#http_body_type' do
    context 'with a HTTP body' do
      let(:web_service_endpoint) { described_class.new(document: document(:patch, '/v1/users/{id}')) }

      it 'should return a string' do
        expect(web_service_endpoint.http_body_type).to eq('UserUpdateRequest')
      end
    end

    context 'without a HTTP body' do
      let(:web_service_endpoint) { described_class.new(document: document(:get, '/v1/users/{id}')) }

      it 'should return nil' do
        expect(web_service_endpoint.http_body_type).to be_nil
      end
    end
  end

  describe '#host' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:get, '/v1/users/{id}')
      )
    end

    it 'should return a string' do
      expect(web_service_endpoint.host).to eq('https://api.appstoreconnect.apple.com')
    end
  end

  describe '#path' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:get, '/v1/users/{id}')
      )
    end

    it 'should return a string' do
      expect(web_service_endpoint.path).to eq('/v1/users/{id}')
    end
  end

  describe '#response_codes' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:patch, '/v1/users/{id}')
      )
    end

    it 'should return an array of hashes' do
      expected_response_codes = [
        { status_code: '200', status_phrase: 'OK', type: 'UserResponse' },
        { status_code: '400', status_phrase: 'Bad Request', type: 'ErrorResponse' },
        { status_code: '403', status_phrase: 'Forbidden', type: 'ErrorResponse' },
        { status_code: '404', status_phrase: 'Not Found', type: 'ErrorResponse' },
        { status_code: '409', status_phrase: 'Conflict', type: 'ErrorResponse' }

      ]
      actual_response_codes = web_service_endpoint.response_codes

      expect(actual_response_codes).to match_array(expected_response_codes)
    end
  end

  describe '#dependencies' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:patch, '/v1/users/{id}')
      )
    end

    it 'should return an array of strings' do
      expected_dependencies = %w[UserUpdateRequest ErrorResponse UserResponse]
      actual_dependencies = web_service_endpoint.dependencies

      expect(actual_dependencies).to match_array(expected_dependencies)
    end
  end

  describe '#url' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:patch, '/v1/users/{id}')
      )
    end

    it 'should return a string' do
      expect(web_service_endpoint.url).to eq('https://api.appstoreconnect.apple.com/v1/users/{id}')
    end
  end

  describe '#description' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:patch, '/v1/users/{id}')
      )
    end

    it 'should return a string' do
      expect(web_service_endpoint.description).to eq(<<~DESCRIPTION.chomp)
        Change a user's role, app visibility information, or other account details.
      DESCRIPTION
    end
  end

  describe '#to_terminal_table' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:patch, '/v1/users/{id}')
      )
    end

    it 'should return a Terminal::Table' do
      terminal_table = web_service_endpoint.to_terminal_table

      expect(terminal_table).to be_a(Terminal::Table)
    end
  end

  describe '#heading' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:patch, '/v1/users/{id}')
      )
    end

    it 'should return a string' do
      expect(web_service_endpoint.heading).to eq('Modify a User Account')
    end
  end

  describe '#inspect' do
    let(:web_service_endpoint) do
      described_class.new(
        document: document(:patch, '/v1/users/{id}')
      )
    end

    it 'should return a string' do
      expect(web_service_endpoint.inspect).to eq(<<~INSPECT.chomp)
        #<ApplePeeler::Documentation::WebServiceEndpoint identifier="#{web_service_endpoint.identifier}">
      INSPECT
    end
  end
end
