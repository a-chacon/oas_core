# frozen_string_literal: true

module OasCore
  module Spec
    require 'digest'

    module Hashable
      def hash_key
        Hashable.generate_hash(hash_representation)
      end

      def hash_representation
        public_instance_variables.sort.to_h { |var| [var, instance_variable_get(var)] }
      end

      def self.generate_hash(obj)
        Digest::MD5.hexdigest(hash_representation_recursive(obj).to_s)
      end

      def public_instance_variables
        instance_variables.select do |var|
          method_name = var.to_s.delete('@')
          respond_to?(method_name) || respond_to?("#{method_name}=")
        end
      end

      def self.hash_representation_recursive(obj)
        case obj
        when Hash
          obj.transform_values { |v| hash_representation_recursive(v) }
        when Array
          obj.map { |v| hash_representation_recursive(v) }
        when Hashable
          hash_representation_recursive(obj.hash_representation)
        else
          # Objects that serialize to a spec (e.g. MediaType) are hashed by
          # their serialized form. Falling through to the default branch would
          # embed their `inspect` output — memory address included — making
          # the digest different on every run.
          obj.respond_to?(:to_spec) ? hash_representation_recursive(obj.to_spec) : obj
        end
      end
    end
  end
end
