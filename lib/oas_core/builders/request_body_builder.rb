# frozen_string_literal: true

module OasCore
  module Builders
    class RequestBodyBuilder
      def initialize(specification)
        @specification = specification
        @request_body = Spec::RequestBody.new(specification)
      end

      def from_oas_route(oas_route)
        tag_request_body = oas_route.tags(:request_body).first
        # TODO: This is for frameowkr specific.
        # if tag_request_body.nil? && OasCore.config.autodiscover_request_body
        #   detect_request_body(oas_route) if %w[create update].include? oas_route.method_name
        return self if tag_request_body.nil?

        from_tags(tag: tag_request_body, examples_tags: oas_route.tags(:request_body_example))

        self
      end

      def from_tags(tag:, examples_tags: [])
        @request_body.description = tag.text
        @request_body.content = ContentBuilder.new(@specification,
                                                   :incoming).with_schema(tag.schema).with_examples_from_tags(examples_tags).build
        @request_body.required = tag.required

        self
      end

      def build
        return {} if @request_body.content == {}

        @request_body
      end

      def reference
        return {} if @request_body.content == {}

        @specification.components.add_request_body(@request_body)
      end
    end
  end
end
