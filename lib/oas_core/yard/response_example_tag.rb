# frozen_string_literal: true

module OasCore
  module YARD
    class ResponseExampleTag < ExampleTag
      attr_accessor :code

      def initialize(tag_name, text, content: nil, code: 200)
        super(tag_name, text, content:)
        @code = code
      end
    end
  end
end
