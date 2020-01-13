# frozen_string_literal: true

require 'tsort'
require 'ruby-graphviz'
require 'securerandom'
require 'tempfile'

class ApplePeeler
  class Graph
    include TSort

    attr_reader :documentation

    def initialize(documentation)
      @nodes = documentation.documentation_by_type.values.flatten
      @documentation_by_identifier = documentation.documentation_by_type.flat_map do |_type, documentations|
        documentations.map { |d| [d.identifier, d] }
      end.to_h
    end

    def tsort_each_node(&block)
      @nodes.each(&block)
    end

    def tsort_each_child(node)
      node.dependencies.map do |_type, identifier|
        @documentation_by_identifier[identifier]
      end
    end

    def to_png
      g = GraphViz.new(:G, type: :digraph, rankdir: 'LR', splines: 'polyline')

      nodes_by_identifier = {}
      tsort.each.with_index do |documentation, _index|
        options = case documentation.class::TYPE
                  when :object then { label: documentation.type, color: 'lightblue' }
                  when :web_service_endpoint then { color: 'orange', label: "#{documentation.http_method.upcase}\n#{documentation.path}" }
                  when :type
                    { label: documentation.type, color: 'lightgray' }
                  else
                    raise 'Unknown Type!'
                  end

        nodes_by_identifier[documentation.identifier] = g.add_nodes(documentation.identifier, { shape: 'box', style: 'filled' }.merge(options)) # TODO
      end

      nodes_by_identifier.each do |from_identifier, from_node|
        @documentation_by_identifier[from_identifier].dependencies.each do |to_identifier|
          to_documentation = @documentation_by_identifier[to_identifier]

          if to_documentation.nil?
            STDERR.puts "Unable to map #{from_identifier} -> #{to_identifier}"
            next
          end

          to_node = nodes_by_identifier.fetch(to_documentation.identifier)

          g.add_edges(from_node, to_node)
        end
      end
     
      tempfile = Tempfile.new(%w(appstoreconnectapi .png))
      g.output(png: tempfile.path)
      
      tempfile.read
    end
  end
end
