# frozen_string_literal: true

require 'apple_peeler'

class ApplePeeler
  class CLI
    def self.run
      documentation = ApplePeeler::Documentation.new
      documentation.load!

      open_api = OpenAPI.new(documentation)


      File.write("/Users/kyledecot/Desktop/schema.yml", open_api.to_yaml)
      # case format
      # when 'png' then puts documentation.to_graph.to_png
      # when 'json' then puts documentation.to_json
      #when 'yaml' then 
        # puts documentation.to_yaml
      # else
        # puts "invalid format #{format}"
      # end
    end
  end
end
