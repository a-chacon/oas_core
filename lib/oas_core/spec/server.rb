# frozen_string_literal: true

module OasCore
  module Spec
    class Server
      include Specable
      attr_accessor :url, :description, :name

      def initialize(url:, description:, name: nil)
        @url = url
        @description = description
        @name = name
      end

      def oas_fields
        %i[url description name]
      end
    end
  end
end
