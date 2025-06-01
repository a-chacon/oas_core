# frozen_string_literal: true

module OasCore
  module Spec
    class RequestBody
      include Specable
      include Hashable

      attr_accessor :description, :content, :required

      def initialize(specification)
        @specification = specification
        @description = ''
        @content = {} # a hash with media type objects
        @required = false
      end

      def oas_fields
        %i[description content required]
      end
    end
  end
end
