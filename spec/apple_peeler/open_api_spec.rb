RSpec.describe ApplePeeler::OpenAPI do 
  let(:version) { "3.0.0" }
  let(:server_url) { "https://api.appstoreconnect.apple.com" }
  let(:app_store_connect_documentation) { ApplePeeler::Documentation.new.load! }

  describe "#to_yaml" do 
    subject(:api) { described_class.new(app_store_connect_documentation) }

    it 'should return a string' do 
      expect(api.to_yaml).to eq(<<~YAML)
      ---
      openapi: #{version}
      servers:
      - url: #{server_url}
      components:
        schemas:
          AppResponse:
            properties: {}
      YAML
    end 
  end 
end 
