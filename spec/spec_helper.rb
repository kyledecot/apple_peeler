# frozen_string_literal: true

require 'bundler/setup'
require 'webmock/rspec'
require 'simplecov'
require 'pry'
require 'vcr'

SimpleCov.start do
  add_filter('/spec/')
end

require 'apple_peeler'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.include ApplePeeler::Spec::Helpers

  config.before(:each) do
    stub_request(:any, /api.appstoreconnect.apple.com/)
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
