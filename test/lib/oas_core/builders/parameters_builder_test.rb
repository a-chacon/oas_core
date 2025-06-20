# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Builders
    class ParametersBuilderTest < Minitest::Test
      def setup
        @specification = Spec::Specification.new
        @builder = ParametersBuilder.new(@specification)
      end

      # def test_from_oas_route_with_parameter_tags
      #   parameter_tag = build(:parameter_tag, name: 'query_param', location: 'query')
      #   oas_route = build(:oas_route, tags: [parameter_tag])
      #
      #   parameters = @builder.from_oas_route(oas_route).build
      #
      #   assert_equal 1, parameters.size
      #   assert_equal 'query_param', parameters.first.name
      #   assert_equal 'query', parameters.first.in
      # end
      #
      # def test_from_oas_route_with_path_params
      #   oas_route = build(:oas_route, path: '/example/:id')
      #
      #   parameters = @builder.from_oas_route(oas_route).build
      #
      #   assert_equal 1, parameters.size
      #   assert_equal 'id', parameters.first.name
      #   assert_equal 'path', parameters.first.in
      # end
      #
      # def test_from_oas_route_with_parameter_reference_tags
      #   parameter_ref_tag = build(:parameter_reference_tag)
      #   oas_route = build(:oas_route, tags: [parameter_ref_tag])
      #
      #   parameters = @builder.from_oas_route(oas_route).build
      #
      #   assert_equal 1, parameters.size
      #   assert parameters.first.is_a?(Spec::Reference)
      #   assert_equal '#/components/schemas/Example', parameters.first.ref
      # end
      #
      # def test_from_oas_route_with_duplicate_path_params
      #   oas_route = build(:oas_route, path: '/example/:id')
      #   parameter_tag = build(:parameter_tag, name: 'id', location: 'path')
      #   oas_route.tags << parameter_tag
      #
      #   parameters = @builder.from_oas_route(oas_route).build
      #
      #   assert_equal 1, parameters.size
      #   assert_equal 'id', parameters.first.name
      # end
    end
  end
end
