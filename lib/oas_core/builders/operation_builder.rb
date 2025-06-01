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
        @operation.request_body = RequestBodyBuilder.new(@specification).from_oas_route(oas_route).reference
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
        oas_route.tags(:summary).first.try(:text) || generate_crud_name(oas_route.method_name,
                                                                        oas_route.controller.downcase) || "#{oas_route.verb} #{oas_route.path}"
      end

      def extract_operation_id(oas_route:)
        "#{oas_route.method_name}#{oas_route.path.gsub('/', '_').gsub(/[{}]/, '')}"
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
          tag = oas_route.path.split('/').reject(&:empty?).first.try(:titleize)
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

      def generate_crud_name(method, controller)
        controller_name = controller.to_s.underscore.humanize.downcase.pluralize

        case method.to_sym
        when :index
          "List #{controller_name}"
        when :show
          "View #{controller_name.singularize}"
        when :create
          "Create new #{controller_name.singularize}"
        when :update
          "Update #{controller_name.singularize}"
        when :destroy
          "Delete #{controller_name.singularize}"
        end
      end
    end
  end
end
