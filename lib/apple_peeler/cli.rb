require 'apple_peeler'
require 'gli'
require 'logger'


class ApplePeeler
  class CLI 
    extend GLI::App

    LOGGER = Logger.new(STDOUT)

    command :appstoreconnectapi do |run|
      run.action do |_, _, _| 
        documentation = ApplePeeler::Documentation.new(
          on_documentation: proc { |d| print "."  }
        )

        documentation.load!
      end 
    end 
  end 
end 
