# frozen_string_literal: true

RSpec.describe ApplePeeler::Documentation::Type do
  let(:url) { 'https://developer.apple.com/documentation/appstoreconnectapi/capabilitytype' }
  let(:documentation) { described_class.new(document: document_for(url: url)) }

  describe '#identifier' do
    it 'should return a string' do
      expect(documentation.identifier).to eq('CapabilityType')
    end
  end

  describe '#type' do
    it 'should return a string' do
      expect(documentation.type).to eq('CapabilityType')
    end
  end

  describe '#possible_values' do
    it 'should return an array of strings' do
      expected_possible_values = %w[ICLOUD IN_APP_PURCHASE GAME_CENTER PUSH_NOTIFICATIONS WALLET INTER_APP_AUDIO MAPS ASSOCIATED_DOMAINS PERSONAL_VPN APP_GROUPS HEALTHKIT HOMEKIT WIRELESS_ACCESSORY_CONFIGURATION APPLE_PAY DATA_PROTECTION SIRIKIT NETWORK_EXTENSIONS MULTIPATH HOT_SPOT NFC_TAG_READING CLASSKIT AUTOFILL_CREDENTIAL_PROVIDER ACCESS_WIFI_INFORMATION]
      actual_possible_values = documentation.possible_values

      expect(actual_possible_values).to match_array(expected_possible_values)
    end
  end
end
