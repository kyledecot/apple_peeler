# frozen_string_literal: true

require 'fileutils'
require 'digest'

require 'apple_peeler/cache/persistence'

class ApplePeeler
  class Cache
    def initialize
      @cache = {}
      @persistence = Persistence.new
    end

    def [](key)
      @cache[key] ||= begin
        @persistence.get(filename(key)) if @persistence.exists?(filename(key))
      end

      @cache[key]
    end

    def []=(key, value)
      @cache[key] = value
      @persistence.persist!(filename(key), value) unless @persistence.exists?(filename(key))
    end

    def clear!
      @cache = {}
      @persistence.clear!

      true
    end

    private

    def filename(key)
      @filename ||= {}
      @filename[key] ||= Digest::MD5.new.<<(key).hexdigest

      @filename[key]
    end
  end
end
