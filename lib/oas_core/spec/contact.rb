# frozen_string_literal: true

module OasCore
  module Spec
    class Contact
      include Specable
      attr_accessor :name, :url, :email

      def initialize(**kwargs)
        @name = kwargs[:name] || ''
        @url = kwargs[:url] || ''
        @email = kwargs[:email] || ''
      end

      def oas_fields
        %i[name url email]
      end
    end
  end
end
