# frozen_string_literal: true

module OasCore
  module Spec
    module Specable
      def oas_fields
        []
      end

      def to_spec
        oas_fields.each_with_object({}) do |var, hash|
          key = var.to_s.camelize(:lower).to_sym
          value = send(var)
          processed_value = process_value(value)
          hash[key] = processed_value unless valid_processed_value?(processed_value)
        end
      end

      # rubocop:disable Lint/UnusedMethodArgument
      def as_json(options = nil)
        to_spec
      end
      # rubocop:enable Lint/UnusedMethodArgument

      private

      def process_value(value)
        if value.respond_to?(:to_spec)
          value.to_spec
        elsif value.is_a?(Array)
          process_array(value)
        elsif value.is_a?(Hash)
          process_hash(value)
        else
          value
        end
      end

      def process_array(array)
        array.all? { |elem| elem.respond_to?(:to_spec) } ? array.map(&:to_spec) : array
      end

      def process_hash(hash)
        hash.transform_values { |val| val.respond_to?(:to_spec) ? val.to_spec : val }
      end

      def valid_processed_value?(processed_value)
        ((processed_value.is_a?(Hash) || processed_value.is_a?(Array)) && processed_value.empty?) || processed_value.nil?
      end

      def snake_to_camel(snake_str)
        words = snake_str.to_s.split('_')
        words[1..].map!(&:capitalize)
        (words[0] + words[1..].join).to_sym
      end
    end
  end
end
