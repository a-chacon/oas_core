# frozen_string_literal: true

module OasCore
  module Builders
    class ResponseBuilder
      def initialize(specification)
        @specification = specification
        @response = Spec::Response.new(specification)
      end

      def with_description(description)
        @response.description = description

        self
      end

      def with_content(content)
        @response.content = content

        self
      end

      def with_code(code)
        @response.code = code

        self
      end

      def from_tag(tag)
        @response.code = tag.code.to_i
        @response.description = tag.text
        @response.content = ContentBuilder.new(@specification).with_schema(tag.content).build

        self
      end

      def build
        @response
      end
    end
  end
end
