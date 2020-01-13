# frozen_string_literal: true

RSpec.describe ApplePeeler::Documentation::Object do
  let(:documentation) do
    described_class.new(
      document: document('', '/appstoreconnectapi/userresponse')
    )
  end

  describe '#type' do
    it 'should return a string' do
      expect(documentation.type).to eq('UserResponse')
    end
  end

  describe '#property_names' do
    it 'should return an array of string' do
      expected_property_names = %w[data links included]
      actual_property_names = documentation.property_names

      expect(actual_property_names).to eq(expected_property_names)
    end
  end

  describe '#property_types' do
    it 'should return an array of string' do
      expected_property_types = %w[User DocumentLinks App]
      actual_property_types = documentation.property_types

      expect(actual_property_types).to eq(expected_property_types)
    end
  end

  describe '#dependencies' do
    it 'should return an array of strings' do
      expected_dependencies = %w[User DocumentLinks App]
      actual_dependencies = documentation.dependencies

      expect(actual_dependencies).to eq(expected_dependencies)
    end
  end
end
