# frozen_string_literal: true

module OasCore
  module Builders
    class ResponsesBuilder
      def initialize(specification, content_builder: ContentBuilder, response_builder: ResponseBuilder,
                     json_schema_generator: JsonSchemaGenerator, utils: Utils)
        @specification = specification
        @content_builder = content_builder
        @response_builder = response_builder
        @json_schema_generator = json_schema_generator
        @utils = utils
        @responses = Spec::Responses.new(specification)
      end

      def from_oas_route(oas_route)
        oas_route.tags(:response).each do |tag|
          content = @content_builder.new(@specification).with_schema(tag.content).with_examples_from_tags(oas_route.tags(:response_example).filter do |re|
            re.code == tag.code
          end).build
          response = @response_builder.new(@specification).with_code(tag.code.to_i).with_description(tag.text).with_content(content).build

          @responses.add_response(response)
        end

        self
      end

      def add_default_responses(oas_route, security)
        return self unless OasCore.config.set_default_responses

        common_errors = determine_common_errors(oas_route, security)
        add_responses_for_errors(common_errors)

        self
      end

      def build
        @responses
      end

      private

      def determine_common_errors(oas_route, security)
        # TODO: this is Rails focus solution.
        #   We need a framework agnostic solution or simple remove and give this responsability to adapters.
        common_errors = []
        common_errors.push(:unauthorized, :forbidden, :internal_server_error) if security

        case oas_route.method_name
        when 'show', 'destroy'
          common_errors.push(:not_found)
        when 'create'
          common_errors.push(:unprocessable_entity)
        when 'update'
          common_errors.push(:not_found, :unprocessable_entity)
        end

        OasCore.config.possible_default_responses & common_errors
      end

      def add_responses_for_errors(errors)
        errors.each do |error|
          response_body = resolve_response_body(error)
          content = @content_builder.new(@specification).with_schema(@json_schema_generator.process_string(response_body)[:json_schema]).build
          code = @utils.status_to_integer(error)
          response = @response_builder.new(@specification).with_code(code).with_description(@utils.get_definition(code)).with_content(content).build

          @responses.add_response(response) if @responses.responses[response.code].nil?
        end
      end

      def resolve_response_body(error)
        OasCore.config.public_send("response_body_of_#{error}")
      rescue StandardError
        OasCore.config.response_body_of_default
      end
    end
  end
end
