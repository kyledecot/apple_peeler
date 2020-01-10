# frozen_string_literal: true

require 'fileutils'

class ApplePeeler
  class Cache
    class Persistence
      attr_reader :directory

      def initialize
        @directory = File.expand_path('../../../tmp/cache', __dir__)
        FileUtils.mkdir_p(@directory)
      end

      def all
        Dir.glob("#{absolute_path('.')}/*")
      end

      def exists?(key)
        File.exist?(absolute_path(key))
      end

      def get(key)
        File.read(absolute_path(key))
      end

      def persist!(key, value)
        File.write(absolute_path(key), value)
      end

      def clear!
        FileUtils.rm_rf(absolute_path('.'), secure: true)
      end

      private

      def absolute_path(key)
        File.join(@directory, key)
      end
    end
  end
end
