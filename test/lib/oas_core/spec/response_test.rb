# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Spec
    class ResponseTest < Minitest::Test
      def setup
        @specification = Specification.new
        @response = Response.new(@specification)
      end

      def test_initialize_default_values
        assert_equal 200, @response.code
        assert_equal '', @response.description
        assert_equal({}, @response.content)
      end

      def test_oas_fields
        assert_equal %i[description content], @response.oas_fields
      end

      def test_to_spec_with_empty_fields
        spec = @response.to_spec
        assert_equal({ description: '' }, spec)
      end

      def test_to_spec_with_content
        media_type = MediaType.new(@specification)
        media_type.schema = { type: 'string' }
        @response.content = { 'application/json' => media_type }

        spec = @response.to_spec
        expected = {
          description: '',
          content: {
            'application/json' => { schema: { type: 'string' } }
          }
        }
        assert_equal expected, spec
      end
    end
  end
end
