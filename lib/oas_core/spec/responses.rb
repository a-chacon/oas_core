# frozen_string_literal: true

module OasCore
  module Spec
    class Responses
      include Specable
      attr_accessor :responses

      def initialize(specification)
        @specification = specification
        @responses = {}
      end

      def add_response(response)
        @responses[response.code] = @specification.components.add_response(response)
      end

      def to_spec
        @responses.transform_values(&:to_spec)
      end
    end
  end
end
