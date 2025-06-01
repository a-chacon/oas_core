# frozen_string_literal: true

require 'test_helper'

module OasCore
  class UtilsTest < Minitest::Test
    def test_hash_to_json_schema
      result = OasCore::Utils.hash_to_json_schema({ name: 'String', coords: 'Array<Float>' })
      assert result.key? :properties
      assert result.key? :type
      assert_equal [], result[:required]
    end

    def test_hash_to_properties
      hash = { name: String, nested: { age: Integer } }
      result = OasCore::Utils.hash_to_properties(hash)
      assert_equal 'string', result[:name][:type]
      assert_equal 'object', result[:nested][:type]
      assert_equal 'number', result[:nested][:properties][:age][:type]
    end

    def test_ruby_type_to_json_type
      assert_equal 'string', OasCore::Utils.ruby_type_to_json_type('String')
      assert_equal 'number', OasCore::Utils.ruby_type_to_json_type('Integer')
      assert_equal 'boolean', OasCore::Utils.ruby_type_to_json_type('TrueClass')
      assert_equal 'string', OasCore::Utils.ruby_type_to_json_type('UnknownClass')
    end

    def test_status_to_integer
      assert_equal 200, OasCore::Utils.status_to_integer(nil)
      assert_equal 200, OasCore::Utils.status_to_integer(:ok)
      assert_equal 200, OasCore::Utils.status_to_integer('ok')
      assert_equal 404, OasCore::Utils.status_to_integer(:not_found)
      assert_equal 500, OasCore::Utils.status_to_integer(500)
      assert_raises(ArgumentError) { OasCore::Utils.status_to_integer(:unknown) }
    end

    def test_get_definition
      assert_equal 'The request has succeeded.', OasCore::Utils.get_definition(200)
      assert_equal 'Definition not found for status code 999', OasCore::Utils.get_definition(999)
    end

    def test_class_to_symbol
      klass = Class.new { def self.name = 'SomeClass' }
      assert_equal :some_class, OasCore::Utils.class_to_symbol(klass)
    end
  end
end
