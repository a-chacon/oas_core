# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Spec
    class MediaTypeTest < Minitest::Test
      def setup
        @media_type = MediaType.new(OasCore::Spec::Specification.new)
      end

      def test_initialize_default_values
        assert_equal({}, @media_type.schema)
        assert_equal({}, @media_type.example)
        assert_equal({}, @media_type.examples)
        assert_nil @media_type.encoding
      end

      def test_oas_fields
        assert_equal %i[schema example examples encoding], @media_type.oas_fields
      end

      def test_to_spec_with_empty_fields
        spec = @media_type.to_spec
        assert_empty spec
      end

      def test_to_spec_with_schema_as_hash
        @media_type.schema = { type: 'string' }
        spec = @media_type.to_spec
        assert_equal({ schema: { type: 'string' } }, spec)
      end

      def test_to_spec_with_schema_as_reference
        reference = OasCore::Spec::Reference.new('#/components/schemas/User')
        @media_type.schema = reference
        spec = @media_type.to_spec
        assert_equal({ schema: { '$ref' => '#/components/schemas/User' } }, spec)
      end

      def test_to_spec_with_examples_as_hash
        @media_type.examples = { user: { name: 'John Doe' } }
        spec = @media_type.to_spec
        assert_equal({ examples: { user: { name: 'John Doe' } } }, spec)
      end

      def test_to_spec_with_examples_as_reference
        reference = OasCore::Spec::Reference.new('#/components/examples/UserExample')
        @media_type.examples = { user: reference }
        spec = @media_type.to_spec
        assert_equal({ examples: { user: { '$ref' => '#/components/examples/UserExample' } } }, spec)
      end
    end
  end
end
