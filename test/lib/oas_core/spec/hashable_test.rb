# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Spec
    class HashableTest < Minitest::Test
      def setup
        @specification = Specification.new
      end

      def build_response
        media_type = MediaType.new(@specification)
        media_type.schema = { type: 'object', properties: { error: { type: 'string' } } }
        media_type.examples = { example: { value: { error: 'unauthorized' } } }

        response = Response.new(@specification)
        response.code = 401
        response.description = 'Missing or invalid API key'
        response.content = { 'application/json': media_type }
        response
      end

      def test_hash_key_is_stable_across_equal_object_graphs
        # Two separately built but structurally identical responses must share
        # a hash key. Before the fix, the MediaType inside content fell through
        # to `inspect` — memory address included — so every instance (and every
        # process) produced a different digest: committed specs churned on each
        # regeneration, and identical responses never deduplicated.
        assert_equal build_response.hash_key, build_response.hash_key
      end

      def test_hash_key_changes_when_content_changes
        other = build_response
        other.content[:'application/json'].schema = { type: 'string' }

        refute_equal build_response.hash_key, other.hash_key
      end

      def test_hash_key_recurses_nested_hashables
        # A Hashable nested inside another Hashable's representation must be
        # reduced to plain data too, not left as a live object.
        parameter = Parameter.new(@specification)
        parameter.name = 'kind'
        parameter.in = 'path'

        representation = Hashable.hash_representation_recursive({ parameter: parameter })

        assert_kind_of Hash, representation[:parameter]
        refute_match(/0x[0-9a-f]+/, representation.to_s)
      end

      def test_hash_representation_has_no_object_addresses
        representation = Hashable.hash_representation_recursive(build_response.hash_representation)

        refute_match(/0x[0-9a-f]+/, representation.to_s)
      end
    end
  end
end
