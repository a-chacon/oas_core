# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Builders
    class ContentBuilderTest < Minitest::Test
      def setup
        @specification = Minitest::Mock.new
        @components = Minitest::Mock.new
        @specification.expect(:components, @components)
        @context = :incoming
      end

      def test_initialize
        builder = ContentBuilder.new(@specification, @context)
        assert_equal @context, builder.instance_variable_get(:@context)
        assert_instance_of Spec::MediaType, builder.instance_variable_get(:@media_type)
      end

      def test_with_schema
        schema = { type: 'object', properties: { name: { type: 'string' } } }
        @components.expect(:add_schema, '#/components/schemas/User', [schema])
        builder = ContentBuilder.new(@specification, @context)
        builder.with_schema(schema)
        assert_equal '#/components/schemas/User', builder.instance_variable_get(:@media_type).schema
      end

      def test_with_examples
        examples = { 'example1' => { summary: 'Example 1', value: { name: 'John' } } }
        @components.expect(:add_example, '#/components/examples/example1', [examples])
        builder = ContentBuilder.new(@specification, @context)
        builder.with_examples(examples)
        assert_equal '#/components/examples/example1', builder.instance_variable_get(:@media_type).examples
      end

      def test_with_examples_from_tags
        tag = FactoryBot.build(:request_body_example_tag)
        @components.expect(:add_example, '#/components/examples/example1', [Hash])
        builder = ContentBuilder.new(@specification, @context)
        builder.with_examples_from_tags([tag])
        assert_equal '#/components/examples/example1', builder.instance_variable_get(:@media_type).examples['example_request_body_example_description']
      end

      def test_build
        builder = ContentBuilder.new(@specification, @context)
        result = builder.build
        assert_equal({ 'application/json': builder.instance_variable_get(:@media_type) }, result)
      end
    end
  end
end
