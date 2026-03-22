# frozen_string_literal: true

require 'test_helper'

module OasCore
  class JsonSchemaGeneratorTest < Minitest::Test
    def test_process_string
      input = '!Hash{message: !String, data: Hash{availabilities: Array<String>, details: Array<Hash{id: !Integer, name: !String}>}, metadata: Hash{id: !Integer, tags: Array<String>}}'
      result = JsonSchemaGenerator.process_string(input)

      assert_equal true, result[:required]
      assert_equal 'object', result[:json_schema][:type]
      assert_equal ['message'], result[:json_schema][:required]
      assert_equal 'string', result[:json_schema][:properties][:message][:type]
      assert_equal 'array', result[:json_schema][:properties][:data][:properties][:availabilities][:type]
      assert_equal %w[id name], result[:json_schema][:properties][:data][:properties][:details][:items][:required]
    end

    def test_parse_type_hash
      input = '!Hash{key: String, required_key: !Integer}'
      result = JsonSchemaGenerator.parse_type(input)

      assert_equal :object, result[:type]
      assert_equal true, result[:required]
      assert_equal false, result[:properties][:key][:required]
      assert_equal true, result[:properties][:required_key][:required]
    end

    def test_parse_type_array
      input = 'Array<String>'
      result = JsonSchemaGenerator.parse_type(input)

      assert_equal :array, result[:type]
      assert_equal false, result[:required]
      assert_equal :string, result[:items][:type]
    end

    def test_parse_type_primitive
      input = '!Integer'
      result = JsonSchemaGenerator.parse_type(input)

      assert_equal :integer, result[:type]
      assert_equal true, result[:required]
    end

    def test_parse_object_properties
      input = 'key1: String, key2: !Integer, key3: Array<Hash{nested: !Boolean}>'
      result = JsonSchemaGenerator.parse_object_properties(input)

      assert_equal 3, result.size
      assert_equal :string, result[:key1][:type]
      assert_equal true, result[:key2][:required]
      assert_equal :array, result[:key3][:type]
      assert_equal :object, result[:key3][:items][:type]
      assert_equal true, result[:key3][:items][:properties][:nested][:required]
    end

    def test_to_json_schema_object
      input = {
        type: :object,
        properties: {
          key1: { type: :string, required: false },
          key2: { type: :integer, required: true }
        }
      }
      result = JsonSchemaGenerator.to_json_schema(input)

      assert_equal 'object', result[:type]
      assert_equal ['key2'], result[:required]
      assert_equal 'string', result[:properties][:key1][:type]
      assert_equal 'integer', result[:properties][:key2][:type]
    end

    def test_to_json_schema_array
      input = {
        type: :array,
        items: { type: :string, required: false }
      }
      result = JsonSchemaGenerator.to_json_schema(input)

      assert_equal 'array', result[:type]
      assert_equal 'string', result[:items][:type]
    end

    def test_to_json_schema_primitive
      input = { type: :boolean, required: true }
      result = JsonSchemaGenerator.to_json_schema(input)

      assert_equal 'boolean', result[:type]
    end

    # Tests for JSON Schema type compliance
    # JSON Schema only allows these types: string, number, integer, boolean, array, object, null
    # See: https://json-schema.org/understanding-json-schema/reference/type

    def test_ruby_type_to_json_schema_type_hash_returns_object
      # Bug: Hash type currently returns { type: 'hash' } which is invalid JSON Schema
      # It should return { type: 'object' }
      result = JsonSchemaGenerator.ruby_type_to_json_schema_type(:hash)

      assert_equal 'object', result[:type],
                   "JSON Schema does not support 'hash' type - must use 'object'"
    end

    def test_ruby_type_to_json_schema_type_float_returns_number
      # Bug: Float type currently returns { type: 'float' } which is invalid JSON Schema
      # It should return { type: 'number' }
      result = JsonSchemaGenerator.ruby_type_to_json_schema_type(:float)

      assert_equal 'number', result[:type],
                   "JSON Schema does not support 'float' type - must use 'number'"
    end

    def test_plain_hash_type_in_process_string
      # When using just 'Hash' (without field definitions), it should produce valid JSON Schema
      input = 'Hash'
      result = JsonSchemaGenerator.process_string(input)

      assert_equal 'object', result[:json_schema][:type],
                   "Plain Hash type should convert to 'object' in JSON Schema"
    end

    def test_plain_hash_type_as_property_value
      # When Hash is used as a property type without field definitions
      input = 'Hash{metadata: Hash}'
      result = JsonSchemaGenerator.process_string(input)

      assert_equal 'object', result[:json_schema][:properties][:metadata][:type],
                   "Hash property should have type 'object' not 'hash'"
    end

    def test_float_type_in_process_string
      # When using Float type
      input = 'Float'
      result = JsonSchemaGenerator.process_string(input)

      assert_equal 'number', result[:json_schema][:type],
                   "Float type should convert to 'number' in JSON Schema"
    end

    def test_float_type_as_property_value
      # When Float is used as a property type
      input = 'Hash{price: Float, quantity: Integer}'
      result = JsonSchemaGenerator.process_string(input)

      assert_equal 'number', result[:json_schema][:properties][:price][:type],
                   "Float property should have type 'number' not 'float'"
    end

    def test_nested_hash_and_float_types
      # Complex nested structure with both problematic types
      input = 'Hash{data: Hash, stats: Hash{average: Float, count: Integer}}'
      result = JsonSchemaGenerator.process_string(input)

      # Nested plain Hash
      assert_equal 'object', result[:json_schema][:properties][:data][:type],
                   "Nested plain Hash should have type 'object'"

      # Nested object with Float property
      assert_equal 'number', result[:json_schema][:properties][:stats][:properties][:average][:type],
                   "Nested Float property should have type 'number'"
    end

    def test_all_valid_json_schema_types
      # Verify all valid JSON Schema primitive types are correctly mapped
      valid_types = {
        'string' => 'string',
        'integer' => 'integer',
        'boolean' => 'boolean',
        'nil' => 'null'
      }

      valid_types.each do |ruby_type, json_type|
        result = JsonSchemaGenerator.ruby_type_to_json_schema_type(ruby_type.to_sym)
        assert_equal json_type, result[:type], "#{ruby_type} should map to #{json_type}"
      end
    end
  end
end
