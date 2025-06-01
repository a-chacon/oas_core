# frozen_string_literal: true

module OasCore
  module Spec
    class Server
      include Specable
      attr_accessor :url, :description

      def initialize(url:, description:)
        @url = url
        @description = description
      end

      def oas_fields
        %i[url description]
      end
    end
  end
end
