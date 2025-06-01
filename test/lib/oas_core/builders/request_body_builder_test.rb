# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Builders
    class RequestBodyBuilderTest < Minitest::Test
      def setup
        @specification = Spec::Specification.new
      end

      def test_builds_request_body_from_tags
        request_body_tag = build(:request_body_tag, text: 'User creation', required: true)
        example_tags = [
          build(:request_body_example_tag),
          build(:request_body_example_tag, :with_complex_content)
        ]
        oas_route = build(:oas_route, tags: [request_body_tag] + example_tags)

        builder = RequestBodyBuilder.new(@specification)
        builder.from_oas_route(oas_route)
        request_body = builder.build

        assert_equal 'User creation', request_body.description
        assert request_body.required
        refute_empty request_body.content
      end

      def test_returns_empty_hash_when_no_request_body_tag_is_present
        oas_route = build(:oas_route, tags: [])

        builder = RequestBodyBuilder.new(@specification)
        builder.from_oas_route(oas_route)
        request_body = builder.build

        assert_equal({}, request_body)
      end

      def test_reference_adds_request_body_to_components_and_returns_reference
        request_body_tag = build(:request_body_tag)
        oas_route = build(:oas_route, tags: [request_body_tag])

        builder = RequestBodyBuilder.new(@specification)
        builder.from_oas_route(oas_route)
        reference = builder.reference

        assert_equal(OasCore::Spec::Reference, reference.class)
      end
    end
  end
end
