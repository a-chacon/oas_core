# frozen_string_literal: true

module OasCore
  module Spec
    class Tag
      include Specable

      attr_accessor :name, :description

      def initialize(name:, description:)
        @name = name.titleize
        @description = description
      end

      def oas_fields
        %i[name description]
      end
    end
  end
end
