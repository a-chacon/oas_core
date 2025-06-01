# frozen_string_literal: true

module OasCore
  module Builders
    class SpecificationBuilder
      def initialize
        @specification = Spec::Specification.new
      end

      def with_oas_routes(oas_routes)
        grouped_routes = oas_routes.group_by(&:path)
        grouped_routes.each do |path, routes|
          @specification.paths.add_path(path, routes)
        end
      end

      def build
        @specification
      end
    end
  end
end
