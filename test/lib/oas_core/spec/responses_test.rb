# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Spec
    class ResponsesTest < Minitest::Test
      def setup
        @specification = Specification.new
        @responses = Responses.new(@specification)
      end

      def test_initialize_default_values
        assert_equal({}, @responses.responses)
      end

      def test_add_response
        response = Response.new(@specification)
        @responses.add_response(response)

        assert_instance_of OasCore::Spec::Reference, @responses.responses[response.code]
        assert_equal response, @specification.components.responses[response.hash_key]
      end

      def test_to_spec
        response = Response.new(@specification)
        @responses.add_response(response)

        spec = @responses.to_spec
        assert_equal 1, spec.keys.length
        assert_equal 200, spec.keys.first
        assert_match %r{#/components/responses/[a-f0-9]+}, spec[200]['$ref']
      end

      def test_add_reference_response
        reference = '#/components/responses/some_reference'
        @responses.add_reference_response(404, reference)

        assert_equal reference, @responses.responses[404]
      end
    end
  end
end
