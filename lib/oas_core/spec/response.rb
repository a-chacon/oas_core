# frozen_string_literal: true

module OasCore
  module Spec
    class Response
      include Specable
      include Hashable

      attr_accessor :code, :description, :content

      def initialize(specification)
        @specification = specification
        @description = ''
        @content = {} # Hash with {content: MediaType}
      end

      def oas_fields
        %i[description content]
      end

      def to_spec
        {
          description: @description,
          content: @content.transform_values(&:to_spec)
        }
      end
    end
  end
end
