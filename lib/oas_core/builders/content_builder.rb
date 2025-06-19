# frozen_string_literal: true

module OasCore
  module Builders
    class ContentBuilder
      def initialize(specification, context)
        @context = context || :incoming
        @specification = specification
        @media_type = Spec::MediaType.new(specification)
        @content_type = 'application/json'
      end

      def with_schema(schema)
        @media_type.schema = if schema.is_a? OasCore::Spec::Reference
                               schema
                             else
                               @specification.components.add_schema(schema)
                             end

        self
      end

      def with_examples(examples)
        @media_type.examples = @specification.components.add_example(examples)

        self
      end

      def with_content_type(content_type)
        @content_type = content_type if content_type && !content_type.empty?

        self
      end

      def with_examples_from_tags(tags)
        @media_type.examples = @media_type.examples.merge(tags.each_with_object({}).with_index(1) do |(example, result), _index|
          key = example.text.downcase.gsub(' ', '_')
          value = {
            'summary' => example.text,
            'value' => example.content
          }
          result[key] = @specification.components.add_example(value)
        end)

        self
      end

      def build
        {
          @content_type => @media_type
        }
      end
    end
  end
end
