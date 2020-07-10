class ApplePeeler
  class OpenAPI
    module Utils 
      # @param documentation [Array<Documentation>]
      # @return Hash<String, Object>
      def self.paths(documentation)
        documentation.map do |d|
          api['paths'][d.path] ||= {}
          api['paths'][d.path][d.http_method.downcase] = {}
          api['paths'][d.path][d.http_method.downcase]['responses'] = {}
        end
      end 
    end 
  end 
end 
