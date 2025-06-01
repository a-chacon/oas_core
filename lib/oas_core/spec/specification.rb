# frozen_string_literal: true

require 'json'

module OasCore
  module Spec
    class Specification
      include Specable
      attr_accessor :components, :info, :openapi, :servers, :tags, :external_docs, :paths

      def initialize
        @components = Components.new(self)
        @info = OasCore.config.info
        @openapi = '3.1.0'
        @servers = OasCore.config.servers
        @tags = OasCore.config.tags
        @external_docs = {}
        @paths = Spec::Paths.new(self)
      end

      def oas_fields
        %i[openapi info servers paths components security tags external_docs]
      end

      # Create the Security Requirement Object.
      # @see https://spec.openapis.org/oas/latest.html#security-requirement-object
      def security
        return [] unless OasCore.config.authenticate_all_routes_by_default

        OasCore.config.security_schemas.map { |key, _| { key => [] } }
      end
    end
  end
end
