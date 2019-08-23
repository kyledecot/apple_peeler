# frozen_string_literal: true

require 'apple_peeler/documentation'
require 'apple_peeler/version'

class ApplePeeler
  Documentation.register(Documentation::Type)
  Documentation.register(Documentation::Object)
  Documentation.register(Documentation::WebServiceEndpoint)
end
