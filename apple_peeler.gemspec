# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'apple_peeler/version'

Gem::Specification.new do |spec|
  spec.name          = 'apple_peeler'
  spec.version       = ApplePeeler::VERSION
  spec.authors       = ['Kyle Decot']
  spec.email         = ['kyle.decot@icloud.com']

  spec.summary       = 'Web Scraper for Apple Documentation'
  spec.homepage      = 'https://github.com/kyledecot/apple_peeler'
  spec.license       = 'MIT'
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'colorize'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.71.0'
  spec.add_development_dependency 'ruby-graphviz'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'terminal-table'
  spec.add_development_dependency 'vcr', '~> 5.0.0'
  spec.add_development_dependency 'webmock', '~> 3.6.0'

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'oas_parser'
  spec.add_runtime_dependency 'ferrum'
end
