# frozen_string_literal: true

require 'apple_peeler'

class ApplePeeler
  class CLI
    def self.run
      documentation = ApplePeeler::Documentation.new(
        on_documentation: proc { |_d| print '.' }
      )

      documentation.load!
    end
  end
end
