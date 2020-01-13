# frozen_string_literal: true

require 'apple_peeler'

class ApplePeeler
  class CLI
    def self.run(filename)
      documentation = ApplePeeler::Documentation.new(
        on_documentation: proc { |_d| print '.' }
      )

      print "\n"

      documentation.load!

      File.write(filename, documentation.to_json)
    end
  end
end
