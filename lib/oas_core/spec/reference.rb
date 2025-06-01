# frozen_string_literal: true

module OasCore
  module Spec
    class Reference
      include Specable
      attr_reader :ref

      def initialize(ref)
        @ref = ref
      end

      def to_spec
        { '$ref' => @ref }
      end
    end
  end
end
