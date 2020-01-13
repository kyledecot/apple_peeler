# frozen_string_literal: true

require 'tsort'
require 'ruby-graphviz'
require 'securerandom'

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
        @documentation_by_identifier.dig(identifier)
      end.compact
    end

    def to_png(filename)
      g = GraphViz.new(:G, type: :digraph, rankdir: 'LR')

      nodes_by_identifier = {}
      tsort.each.with_index do |documentation, _index|
        options = case documentation.class::TYPE
                  when :object then { label: documentation.type, color: 'blue' }
                  when :web_service_endpoint then { color: 'green', label: "#{documentation.http_method.upcase}\n#{documentation.path}" }
                  when :type
                    { label: documentation.type, color: 'yellow' }
                  else
                    raise 'Unknown Type!'
                  end

        nodes_by_identifier[documentation.identifier] = g.add_nodes(documentation.identifier, { shape: 'box' }.merge(options)) # TODO
      end

      nodes_by_identifier.each do |from_identifier, from_node|
        @documentation_by_identifier[from_identifier].dependencies.each do |to_identifier|
          to_documentation = @documentation_by_identifier[to_identifier]

          if to_documentation.nil?
            puts "Unable to map #{from_identifier} -> #{to_identifier}"
            next
          end

          to_node = nodes_by_identifier.fetch(to_documentation.identifier)

          g.add_edges(from_node, to_node, arrowhead: 'halfopen')
        end
      end

      g.output(png: filename)
    end
  end
end
