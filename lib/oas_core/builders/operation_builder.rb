# frozen_string_literal: true

module OasCore
  module Builders
    class OperationBuilder
      def initialize(specification)
        @specification = specification
        @operation = Spec::Operation.new(specification)
      end

      def from_oas_route(oas_route)
        @operation.summary = extract_summary(oas_route:)
        @operation.operation_id = extract_operation_id(oas_route:)
        @operation.description = oas_route.docstring
        @operation.tags = extract_tags(oas_route:)
        @operation.security = extract_security(oas_route:)
        @operation.parameters = ParametersBuilder.new(@specification).from_oas_route(oas_route).build
        @operation.request_body = extract_request_body(oas_route)
        @operation.responses = ResponsesBuilder.new(@specification)
                                               .from_oas_route(oas_route)
                                               .add_default_responses(oas_route, !@operation.security.empty?).build

        self
      end

      def build
        @operation
      end

      private

      def extract_summary(oas_route:)
        summary_tag = oas_route.tags(:summary).first
        summary_tag&.text || generate_crud_name(oas_route.method_name) || "#{oas_route.verb} #{oas_route.path}"
      end

      def extract_operation_id(oas_route:)
        "#{oas_route.verb}_#{oas_route.path.gsub('/', '_')}"
      end

      def extract_tags(oas_route:)
        tags = oas_route.tags(:tags).first
        if tags.nil?
          default_tags(oas_route:)
        else
          tags.text.split(',').map(&:strip).map(&:titleize)
        end
      end

      def default_tags(oas_route:)
        tags = []
        if OasCore.config.default_tags_from == :namespace
          tag = oas_route.path.split('/').reject(&:empty?).first&.titleize
          tags << tag unless tag.nil?
        else
          tags << oas_route.controller.gsub('/', ' ').titleize
        end

        tags
      end

      def extract_security(oas_route:)
        return [] if oas_route.tags(:no_auth).any?

        if (methods = oas_route.tags(:auth).first)
          OasCore.config.security_schemas.keys.map { |key| { key => [] } }.select do |schema|
            methods.types.include?(schema.keys.first.to_s)
          end
        elsif OasCore.config.authenticate_all_routes_by_default
          OasCore.config.security_schemas.keys.map { |key| { key => [] } }
        else
          []
        end
      end

      def generate_crud_name(method)
        {
          index: 'List',
          show: 'View',
          create: 'Create',
          update: 'Update',
          destroy: 'Delete'
        }.fetch(method.to_sym)
      end

      def extract_request_body(oas_route)
        if (ref_tag = oas_route.tags(:request_body_ref).first)
          ref_tag.reference
        else
          RequestBodyBuilder.new(@specification).from_oas_route(oas_route).reference
        end
      end
    end
  end
end
