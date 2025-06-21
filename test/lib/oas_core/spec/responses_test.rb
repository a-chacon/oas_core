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

        assert_equal({ 200 => { '$ref' => '#/components/responses/c3cbab93bbd905e02b9daa07c824b88a' } }, @responses.to_spec)
      end

      def test_add_reference_response
        reference = '#/components/responses/some_reference'
        @responses.add_reference_response(404, reference)

        assert_equal reference, @responses.responses[404]
      end
    end
  end
end
