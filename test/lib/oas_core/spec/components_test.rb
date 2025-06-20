# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Spec
    class ComponentsTest < Minitest::Test
      def setup
        @specification = Specification.new
        @components = Components.new(@specification)
      end

      def test_initialize_default_values
        assert_equal({}, @components.schemas)
        assert_equal({}, @components.parameters)
        assert_equal(OasCore.config.security_schemas, @components.security_schemes)
        assert_equal({}, @components.request_bodies)
        assert_equal({}, @components.responses)
        assert_equal({}, @components.headers)
        assert_equal({}, @components.examples)
        assert_equal({}, @components.links)
        assert_equal({}, @components.callbacks)
      end

      def test_to_spec_with_empty_fields
        spec = @components.to_spec
        assert_equal(
          {
            schemas: {},
            responses: {},
            parameters: {},
            requestBodies: {},
            securitySchemes: OasCore.config.security_schemas,
            headers: {},
            examples: {},
            links: {},
            callbacks: {}
          },
          spec
        )
      end

      def test_add_response
        response = Response.new(@specification)
        reference = @components.add_response(response)
        assert_equal "#/components/responses/#{response.hash_key}", reference.ref
        assert_equal response, @components.responses[response.hash_key]
      end

      def test_add_parameter
        parameter = Parameter.new(@specification)
        reference = @components.add_parameter(parameter)
        assert_equal "#/components/parameters/#{parameter.hash_key}", reference.ref
        assert_equal parameter, @components.parameters[parameter.hash_key]
      end

      def test_add_request_body
        request_body = RequestBody.new(@specification)
        reference = @components.add_request_body(request_body)
        assert_equal "#/components/requestBodies/#{request_body.hash_key}", reference.ref
        assert_equal request_body, @components.request_bodies[request_body.hash_key]
      end

      def test_add_schema_without_title
        schema = { 'type' => 'object' }
        key = Hashable.generate_hash(schema)
        reference = @components.add_schema(schema)
        assert_equal "#/components/schemas/#{key}", reference.ref
        assert_equal schema, @components.schemas[key]
      end

      def test_add_example
        example = { 'name' => 'John Doe' }
        key = Hashable.generate_hash(example)
        reference = @components.add_example(example)
        assert_equal "#/components/examples/#{key}", reference.ref
        assert_equal example, @components.examples[key]
      end
    end
  end
end
