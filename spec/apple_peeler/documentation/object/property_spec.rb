RSpec.describe ApplePeeler::Documentation::Object::Property do 
  describe ".for" do 
    subject { described_class.for(document: document, name: 'id') }

    let(:document) do 
      VCR.use_cassette("bundle_id") do 
        Nokogiri::HTML(
          URI
          .open("https://developer.apple.com/documentation/appstoreconnectapi/bundleid")
          .read
        )
      end 
    end 

    it "should return an instance" do 
      expect(subject)
        .to be_an_instance_of(described_class)
    end 
  end 
end 
