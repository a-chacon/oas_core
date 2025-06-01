# frozen_string_literal: true

module OasCore
  module YARD
    class RequestBodyExampleTag < ExampleTag
      attr_accessor :content

      def initialize(tag_name, text, content: {})
        super
      end
    end
  end
end
