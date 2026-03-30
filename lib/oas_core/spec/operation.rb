# frozen_string_literal: true

module OasCore
  module Spec
    class Operation
      include Specable

      attr_accessor :specification, :tags, :summary, :description, :operation_id, :parameters, :request_body,
                    :responses, :security, :deprecated

      def initialize(specification)
        @specification = specification
        @summary = ''
        @operation_id = ''
        @tags = []
        @description = @summary
        @parameters = []
        @request_body = {}
        @responses =  Spec::Responses.new(specification)
        @security = []
        @deprecated = false
      end

      def oas_fields
        %i[tags summary description operation_id parameters request_body responses security deprecated]
      end
    end
  end
end
