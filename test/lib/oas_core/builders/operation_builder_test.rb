# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Builders
    class OperationBuilderTest < Minitest::Test
      def setup
        @specification = Spec::Specification.new
        @builder = OperationBuilder.new(@specification)
      end

      def test_from_oas_route_with_summary_tag
        oas_route = FactoryBot.build(:oas_route, tags: [FactoryBot.build(:tag, tag_name: 'summary', text: 'Test Summary')])
        operation = @builder.from_oas_route(oas_route).build

        assert_equal 'Test Summary', operation.summary
      end

      def test_from_oas_route_without_summary_tag
        oas_route = FactoryBot.build(:oas_route)
        operation = @builder.from_oas_route(oas_route).build

        assert_equal 'View', operation.summary
      end

      def test_from_oas_route_without_summary_tag_and_custom_action_raises_exception
        oas_route = FactoryBot.build(:oas_route, method_name: 'download', tags: [])
        exception = assert_raises(OasCore::Errors::BuilderError) do
          @builder.from_oas_route(oas_route).build
        end

        assert_equal "Please add summary tag for custom method '#{oas_route.method_name}'", exception.message
      end

      def test_from_oas_route_with_tags_tag
        oas_route = FactoryBot.build(:oas_route, tags: [FactoryBot.build(:tag, tag_name: 'tags', text: 'tag1, tag2')])
        operation = @builder.from_oas_route(oas_route).build

        assert_equal %w[Tag1 Tag2], operation.tags
      end

      def test_from_oas_route_with_default_tags
        oas_route = FactoryBot.build(:oas_route)
        operation = @builder.from_oas_route(oas_route).build

        assert_equal ['Example'], operation.tags
      end

      def test_from_oas_route_with_deprecated_tag
        oas_route = FactoryBot.build(:oas_route, tags: [FactoryBot.build(:tag, tag_name: 'deprecated', text: 'Use another endpoint')])
        operation = @builder.from_oas_route(oas_route).build

        assert_equal true, operation.deprecated
        assert_equal true, operation.to_spec[:deprecated]
      end

      def test_from_oas_route_without_deprecated_tag
        oas_route = FactoryBot.build(:oas_route)
        operation = @builder.from_oas_route(oas_route).build

        assert_equal false, operation.deprecated
        assert_equal false, operation.to_spec[:deprecated]
      end

      def test_from_oas_route_with_auth_tag
        OasCore.config.authenticate_all_routes_by_default = false
        OasCore.config.security_schema = :bearer

        oas_route = FactoryBot.build(:oas_route, tags: [FactoryBot.build(:tag, tag_name: 'auth', types: ['bearer'])])
        operation = @builder.from_oas_route(oas_route).build

        assert_equal [{ bearer: [] }], operation.security

        OasCore.config.authenticate_all_routes_by_default = true
        OasCore.config.security_schema = nil
      end

      def test_from_oas_route_with_no_auth_tag
        OasCore.config.stub(:authenticate_all_routes_by_default, false) do
          oas_route = FactoryBot.build(:oas_route, tags: [FactoryBot.build(:tag, tag_name: 'no_auth')])
          operation = @builder.from_oas_route(oas_route).build

          assert_empty operation.security
        end
      end

      def test_from_oas_route_with_request_body
        oas_route = FactoryBot.build(:oas_route, tags: [FactoryBot.build(:request_body_reference_tag)])
        operation = @builder.from_oas_route(oas_route).build

        assert operation.request_body
        assert_equal '#/components/schemas/Example', operation.request_body.ref
      end

      def test_operation_id_simple_path
        oas_route = FactoryBot.build(:oas_route, verb: 'GET', path: '/users')
        operation = @builder.from_oas_route(oas_route).build

        assert_equal 'GET_users', operation.operation_id
      end

      def test_operation_id_with_single_path_parameter
        oas_route = FactoryBot.build(:oas_route, verb: 'GET', path: '/users/{id}')
        operation = @builder.from_oas_route(oas_route).build

        assert_equal 'GET_users_id', operation.operation_id
      end

      def test_operation_id_with_multiple_path_parameters
        oas_route = FactoryBot.build(:oas_route, verb: 'POST', path: '/products/{slug}/licenses/{key}/validate')
        operation = @builder.from_oas_route(oas_route).build

        assert_equal 'POST_products_slug_licenses_key_validate', operation.operation_id
      end

      def test_operation_id_is_url_safe
        oas_route = FactoryBot.build(:oas_route, verb: 'GET', path: '/items/{item_id}/details/{detail_id}')
        operation = @builder.from_oas_route(oas_route).build

        # operationId must not contain braces (not URL-safe)
        refute_match(/[{}]/, operation.operation_id)
        assert_equal 'GET_items_item_id_details_detail_id', operation.operation_id
      end
    end
  end
end
