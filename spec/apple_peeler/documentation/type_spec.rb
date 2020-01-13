# frozen_string_literal: true

RSpec.describe ApplePeeler::Documentation::Type do
  let(:type) do
    described_class.new(
      document: document('', '/appstoreconnectapi/capabilitytype')
    )
  end

  describe '#type' do
    it 'should return a string' do
      expect(type.type).to eq('CapabilityType')
    end
  end

  describe '#possible_values' do
    it 'should return an array of strings' do
      expected_possible_values = %w[ICLOUD IN_APP_PURCHASE GAME_CENTER PUSH_NOTIFICATIONS WALLET INTER_APP_AUDIO MAPS ASSOCIATED_DOMAINS PERSONAL_VPN APP_GROUPS HEALTHKIT HOMEKIT WIRELESS_ACCESSORY_CONFIGURATION APPLE_PAY DATA_PROTECTION SIRIKIT NETWORK_EXTENSIONS MULTIPATH HOT_SPOT NFC_TAG_READING CLASSKIT AUTOFILL_CREDENTIAL_PROVIDER ACCESS_WIFI_INFORMATION]
      actual_possible_values = type.possible_values

      expect(actual_possible_values).to match_array(expected_possible_values)
    end
  end
end
