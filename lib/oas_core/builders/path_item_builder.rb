# frozen_string_literal: true

module OasCore
  module Builders
    class PathItemBuilder
      def initialize(specification)
        @specification = specification
        @path_item = Spec::PathItem.new(specification)
      end

      def with_oas_routes(oas_routes)
        oas_routes.each do |oas_route|
          oas_route.verb.downcase.split('|').each do |v|
            @path_item.add_operation(v, OperationBuilder.new(@specification).from_oas_route(oas_route).build)
          end
        end

        self
      end

      def build
        @path_item
      end
    end
  end
end
