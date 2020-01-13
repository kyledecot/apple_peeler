# frozen_string_literal: true

require 'bundler/setup'
require 'webmock/rspec'
require 'factory_bot'
require 'simplecov'
require 'timecop'
require 'pry'

SimpleCov.start do
  add_filter('/spec/')
end

require 'apple_peeler'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.include FactoryBot::Syntax::Methods
  config.include ApplePeeler::Spec::Helpers

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:each) do
    stub_request(:any, /api.appstoreconnect.apple.com/)
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
