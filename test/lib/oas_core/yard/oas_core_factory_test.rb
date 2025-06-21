# frozen_string_literal: true

require 'test_helper'

module OasCore
  module YARD
    class OasCoreFactoryTest < Minitest::Test
      def setup
        @factory = OasCoreFactory.new
      end

      def test_parse_tag_with_request_body_returns_request_body_tag_with_hash_structure
        text = 'The user to be created [!Hash{user: Hash{name: String, age: Integer, password: String}}]'
        tag = @factory.parse_tag_with_request_body('request_body', text)

        assert_instance_of RequestBodyTag, tag
        assert_equal true, tag.required
        assert_equal 'request_body', tag.tag_name
        assert_equal 'The user to be created', tag.text
      end

      def test_parse_tag_with_request_body_handles_optional_parameters
        text = 'The user to be created [Hash{user: Hash{name: String, age: Integer, password: String}}]'
        tag = @factory.parse_tag_with_request_body('request_body', text)

        assert_instance_of RequestBodyTag, tag
        assert_equal false, tag.required
      end

      def test_parse_tag_with_request_body_returns_request_body_tag_with_reference
        text = 'The user to be created (multipart/form-data) [!Reference:#/components/content/user]'
        tag = @factory.parse_tag_with_request_body('request_body', text)

        assert_instance_of RequestBodyTag, tag
        assert_equal true, tag.required
        assert_equal OasCore::Spec::Reference, tag.content.class
        assert_equal '#/components/content/user', tag.content.ref
        assert_equal 'multipart/form-data', tag.content_type
      end

      def test_parse_tag_with_request_body_raises_error_for_malformed_input
        text = 'The user to be created [!Hash{user: Hash{name: String, age: Integer, password: String}'
        assert_raises(TagParsingError) do
          @factory.parse_tag_with_request_body('request_body', text)
        end
      end

      def test_parse_tag_with_request_body_example_returns_request_body_example_tag_with_correct_structure
        text = 'A complete User. [JSON{ "user": { "name": "Luis", "age": 30, "password": "MyWeakPassword123"}}]'
        tag = @factory.parse_tag_with_request_body_example('request_body_example', text)

        assert_instance_of RequestBodyExampleTag, tag
        assert_equal 'request_body_example', tag.tag_name
        assert_equal 'A complete User.', tag.text
        assert_nil tag.name
        assert_nil tag.types
        expected = { "user": { "name": 'Luis', "age": 30, "password": 'MyWeakPassword123' } }
        actual = tag.content

        assert_equal(
          expected.deep_stringify_keys,
          actual.deep_stringify_keys
        )
      end

      def test_parse_tag_with_parameter_returns_parameter_tag_with_all_attributes
        text = 'id(path) [!Integer] The user ID'
        tag = @factory.parse_tag_with_parameter('parameter', text)

        assert_instance_of ParameterTag, tag
        assert_equal 'parameter', tag.tag_name
        assert_equal 'The user ID', tag.text
        assert_equal 'id', tag.name
        assert_equal 'path', tag.location
        assert_equal true, tag.required
        assert_nil tag.types
        assert_equal({ type: 'integer' }, tag.schema)
      end

      def test_parse_tag_with_parameter_appends_brackets_to_query_array_parameters
        text = 'ids(query) [!Array<Integer>] List of user IDs'
        tag = @factory.parse_tag_with_parameter('parameter', text)
        assert_instance_of ParameterTag, tag
        assert_equal 'ids[]', tag.name
        assert_equal 'query', tag.location
        assert_equal 'array', tag.schema[:type]
      end

      def test_parse_tag_with_response_returns_response_tag
        text = 'User not found by the provided Id(404) [Hash{success: Boolean, message: String}]'
        tag = @factory.parse_tag_with_response('response', text)
        assert_instance_of ResponseTag, tag
        assert_equal '404', tag.code
      end

      def test_parse_tag_with_response_reference
        text = 'User not found by the provided Id(404) [Reference:#/components/schemas/404]'
        tag = @factory.parse_tag_with_response('response', text)

        assert_equal OasCore::Spec::Reference, tag.content.class
        assert_equal '#/components/schemas/404', tag.content.ref
      end

      def test_parse_tag_with_response_returns_response_tag_using_array_as_response
        text = 'List of Users(200) [Array<Hash{name: String, age: Integer}>]'
        tag = @factory.parse_tag_with_response('response', text)

        assert_equal '200', tag.code
        assert_equal 'response', tag.tag_name
        assert_equal 'List of Users', tag.text
        assert_equal(
          {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                name: { type: 'string' },
                age: { type: 'integer' }
              }
            }
          },
          tag.content
        )
      end

      def test_parse_tag_with_response_example_returns_response_example_tag
        text = 'Invalid Email(422) [JSON{ "success": "false", "errors": [{ "field": "email", "type": "email", "detail": ["Invalid email"]}] }]'
        tag = @factory.parse_tag_with_response_example('response_example', text)
        assert_instance_of ResponseExampleTag, tag
        assert_equal 'Invalid Email', tag.text
      end

      def test_parse_tag_with_response_example_and_reference_content
        text = 'Invalid Email(422) [Reference:#/components/schemas/response_example]'
        tag = @factory.parse_tag_with_response_example('response_example', text)

        assert_instance_of OasCore::Spec::Reference, tag.content
        assert_equal '#/components/schemas/response_example', tag.content.ref
      end

      def test_parse_tag_with_parameter_reference_returns_parameter_reference_tag
        text = '#/components/parameters/one'
        tag = @factory.parse_tag_with_parameter_reference('parameter_reference', text)

        assert_instance_of ParameterReferenceTag, tag
        assert_equal 'parameter_reference', tag.tag_name
        assert_equal '#/components/parameters/one', tag.reference.ref
      end

      def test_parse_tag_with_request_body_reference_returns_request_body_reference_tag
        text = '#/components/requestBodies/one'
        tag = @factory.parse_tag_with_request_body_reference('request_body_reference', text)

        assert_instance_of RequestBodyReferenceTag, tag
        assert_equal 'request_body_reference', tag.tag_name
        assert_equal '#/components/requestBodies/one', tag.reference.ref
      end

      def test_parse_tag_with_response_reference_returns_response_reference_tag
        text = '(405) #/components/responses/one'
        tag = @factory.parse_tag_with_response_reference('response_reference', text)

        assert_instance_of ResponseReferenceTag, tag
        assert_equal 'response_reference', tag.tag_name
        assert_equal '#/components/responses/one', tag.reference.ref
        assert_equal 405, tag.code
      end
    end
  end
end
