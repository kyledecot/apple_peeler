# frozen_string_literal: true

require 'apple_peeler'

class ApplePeeler
  class CLI
    def self.run(format)
      documentation = ApplePeeler::Documentation.new
      documentation.load!

      case format
      when 'png' then puts documentation.to_graph.to_png
      when 'json' then puts documentation.to_json
      else
        puts "invalid format #{format}"
      end
    end
  end
end
