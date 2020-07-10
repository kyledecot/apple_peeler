# frozen_string_literal: true

RSpec.describe ApplePeeler::OpenAPI::Property do
  describe '#to_h' do
    let(:element) do
    end

    let(:documentation) do
      ApplePeeler::Documentation::Object::Property.new(element: element)
    end

    subject(:property) { described_class.new(documentation) }

    it 'should return a hash' do
      expect(property.to_h).to eq({

                                  })
    end
  end
end
