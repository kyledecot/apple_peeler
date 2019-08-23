# App Store Connect

[![Build Status](https://travis-ci.com/kyledecot/apple_peeler.svg?branch=master)](https://travis-ci.com/kyledecot/apple_peeler) [![Gem Version](https://badge.fury.io/rb/apple_peeler.svg)](https://badge.fury.io/rb/apple_peeler) [![Maintainability](https://api.codeclimate.com/v1/badges/eb09ffa68f84f8da0b6d/maintainability)](https://codeclimate.com/github/kyledecot/apple_peeler/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/eb09ffa68f84f8da0b6d/test_coverage)](https://codeclimate.com/github/kyledecot/apple_peeler/test_coverage)

A Ruby interface to the [App Store Connect API](https://developer.apple.com/app-store-connect/api/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apple_peeler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apple_peeler

## Usage

```ruby
client = ApplePeeler::Client.new(
  issuer_id: issuer_id,
  key_id: key_id,
  private_key: private_key
)

client.apps
client.app('1234')
client.builds('1234')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kyledecot/apple_peeler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
