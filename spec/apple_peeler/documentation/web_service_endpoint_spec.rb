# frozen_string_literal: true

RSpec.describe ApplePeeler::Documentation::WebServiceEndpoint do
  describe '#http_body_type' do
    context 'with a HTTP body' do
      let(:documentation) do
        described_class.new(
          document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
        )
      end

      it 'should return a string' do
        expect(documentation.http_body_type).to eq('UserUpdateRequest')
      end
    end

    context 'without a HTTP body' do
      let(:documentation) do
        described_class.new(
          document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/read_user_information')
        )
      end

      it 'should return nil' do
        expect(documentation.http_body_type).to be_nil
      end
    end
  end

  describe '#host' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/read_user_information')
      )
    end

    it 'should return a string' do
      expect(documentation.host).to eq('https://api.appstoreconnect.apple.com')
    end
  end

  describe '#path' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/read_user_information')
      )
    end

    it 'should return a string' do
      expect(documentation.path).to eq('/v1/users/{id}')
    end
  end

  describe '#response_codes' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
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
      actual_response_codes = documentation.response_codes

      expect(actual_response_codes).to match_array(expected_response_codes)
    end
  end

  describe '#http_method' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
      )
    end

    it 'should return a string' do
      expected_http_method = 'PATCH'
      actual_http_method = documentation.http_method

      expect(actual_http_method).to eq(expected_http_method)
    end
  end

  describe '#dependencies' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
      )
    end

    it 'should return an array of strings' do
      expected_dependencies = %w[UserUpdateRequest ErrorResponse UserResponse]
      actual_dependencies = documentation.dependencies

      expect(actual_dependencies).to match_array(expected_dependencies)
    end
  end

  describe '#url' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
      )
    end

    it 'should return a string' do
      expect(documentation.url).to eq('https://api.appstoreconnect.apple.com/v1/users/{id}')
    end
  end

  describe '#description' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
      )
    end

    it 'should return a string' do
      expect(documentation.description).to eq(<<~DESCRIPTION.chomp)
        Change a user's role, app visibility information, or other account details.
      DESCRIPTION
    end
  end

  describe '#to_terminal_table' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
      )
    end

    it 'should return a Terminal::Table' do
      terminal_table = documentation.to_terminal_table

      expect(terminal_table).to be_a(Terminal::Table)
    end
  end

  describe '#heading' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
      )
    end

    it 'should return a string' do
      expect(documentation.heading).to eq('Modify a User Account')
    end
  end

  describe '#inspect' do
    let(:documentation) do
      described_class.new(
        document: document_for(url: 'https://developer.apple.com/documentation/appstoreconnectapi/modify_a_user_account')
      )
    end

    it 'should return a string' do
      expect(documentation.inspect).to eq(<<~INSPECT.chomp)
        #<ApplePeeler::Documentation::WebServiceEndpoint identifier="#{documentation.identifier}">
      INSPECT
    end
  end
end
