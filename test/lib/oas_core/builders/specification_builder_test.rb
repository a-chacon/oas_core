# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Builders
    class SpecificationBuilderTest < Minitest::Test
      def setup
        @builder = SpecificationBuilder.new
      end

      def test_with_oas_routes_groups_routes_by_path
        route1 = FactoryBot.build(:oas_route, path: '/example/:id')
        route2 = FactoryBot.build(:oas_route, path: '/example/:id')
        route3 = FactoryBot.build(:oas_route, path: '/another')

        @builder.with_oas_routes([route1, route2, route3])

        specification = @builder.build
        assert_equal 2, specification.paths.path_items.size
        assert specification.paths.path_items.key?('/example/:id')
        assert specification.paths.path_items.key?('/another')
      end

      def test_with_oas_routes_processes_tags
        route = FactoryBot.build(:oas_route, path: '/example/:id')
        route.tags = [
          FactoryBot.build(:response_tag),
          FactoryBot.build(:response_example_tag),
          FactoryBot.build(:parameter_tag),
          FactoryBot.build(:request_body_tag),
          FactoryBot.build(:request_body_example_tag)
        ]

        @builder.with_oas_routes([route])

        specification = @builder.build
        path_item = specification.paths.path_items['/example/:id']
        assert path_item
        assert path_item.get
        assert_nil path_item.post
      end
    end
  end
end
