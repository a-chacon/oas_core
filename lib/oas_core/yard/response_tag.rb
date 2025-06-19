# frozen_string_literal: true

module OasCore
  module YARD
    class ResponseTag < ::YARD::Tags::Tag
      attr_accessor :content, :code

      # TODO: name == code. The name MUST be changed to code for better understanding
      def initialize(tag_name, description, code, content)
        super(tag_name, description, nil, nil)
        @code = code
        @content = content
      end
    end
  end
end
