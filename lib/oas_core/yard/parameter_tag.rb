# frozen_string_literal: true

module OasCore
  module YARD
    class ParameterTag < ::YARD::Tags::Tag
      attr_accessor :schema, :required, :location

      def initialize(tag_name, name, text, *args, **kwargs)
        super(tag_name, text, nil, name)
        @schema = args[0] || kwargs.fetch(:schema, nil)
        @location = args[1] || kwargs.fetch(:location, nil)
        @required = kwargs.fetch(:required, false)
      end
    end
  end
end
