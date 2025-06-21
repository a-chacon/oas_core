# frozen_string_literal: true

module OasCore
  module YARD
    class ResponseReferenceTag < ReferenceTag
      attr_accessor :code

      def initialize(tag_name, reference, code: 200)
        super(tag_name, reference)
        @code = code
      end
    end
  end
end
