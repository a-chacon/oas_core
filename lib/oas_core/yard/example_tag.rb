# frozen_string_literal: true

module OasCore
  module YARD
    class ExampleTag < ::YARD::Tags::Tag
      attr_accessor :content

      def initialize(tag_name, text, content: {})
        super(tag_name, text, nil, nil)
        @content = content
      end
    end
  end
end
