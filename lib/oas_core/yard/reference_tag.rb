# frozen_string_literal: true

module OasCore
  module YARD
    class ReferenceTag < ::YARD::Tags::Tag
      attr_accessor :reference

      def initialize(tag_name, reference)
        super(tag_name, nil, nil, nil)
        @reference = reference
      end
    end
  end
end
