# frozen_string_literal: true

RSpec.describe ApplePeeler::Documentation::Crawler do
  describe '#visited?' do
    let(:crawler) { described_class.new('https://developer.apple.com') }

    context 'when the URI is visited' do
      let(:uri) { URI('https://developer.apple.com/documentation/appstoreconnectapi/list_users') }

      before do
        crawler.visited_uris << uri
      end

      it 'should return true' do
        expect(crawler.visited?(uri)).to eq(true)
      end
    end

    context 'when the URI is not visited' do
      let(:uri) { URI('https://developer.apple.com/documentation/appstoreconnectapi/list_users') }

      it 'should return false' do
        expect(crawler.visited?(uri)).to eq(false)
      end
    end
  end

  describe '#enqueued?' do
    let(:crawler) { described_class.new('https://developer.apple.com') }

    context 'when the URI is enqueued' do
      let(:uri) { URI('https://developer.apple.com/documentation/appstoreconnectapi/list_users') }

      before do
        crawler.enqueued_uris << uri
      end

      it 'should return true' do
        expect(crawler.enqueued?(uri)).to eq(true)
      end
    end

    context 'when the URI is not enqueued' do
      let(:uri) { URI('https://developer.apple.com/documentation/appstoreconnectapi/list_users') }

      it 'should return false' do
        expect(crawler.enqueued?(uri)).to eq(false)
      end
    end
  end
end
