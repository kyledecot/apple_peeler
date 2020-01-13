# frozen_string_literal: true

class ApplePeeler
  module Identifiable
    def identified_by
      puts 'identified_by called!'
    end
  end
end
