# frozen_string_literal: true

module OasCore
  module Utils
    TYPE_MAPPING = {
      'String' => 'string',
      'Integer' => 'number',
      'Float' => 'number',
      'TrueClass' => 'boolean',
      'FalseClass' => 'boolean',
      'Boolean' => 'boolean',
      'NilClass' => 'null',
      'Hash' => 'object',
      'Object' => 'object',
      'DateTime' => 'string'
    }.freeze

    STATUS_SYMBOL_MAPPING = {
      ok: 200,
      created: 201,
      no_content: 204,
      bad_request: 400,
      unauthorized: 401,
      forbidden: 403,
      not_found: 404,
      unprocessable_entity: 422,
      internal_server_error: 500
    }.freeze

    HTTP_STATUS_DEFINITIONS = {
      200 => 'The request has succeeded.',
      201 => 'The request has been fulfilled and resulted in a new resource being created.',
      404 => 'The requested resource could not be found.',
      401 => 'You are not authorized to access this resource. You need to authenticate yourself first.',
      403 => 'You are not allowed to access this resource. You do not have the necessary permissions.',
      500 => 'An unexpected error occurred on the server. The server was unable to process the request.',
      422 => 'The server could not process the request due to semantic errors. Please check your input and try again.'
    }.freeze

    class << self
      def hash_to_json_schema(hash)
        {
          type: 'object',
          properties: hash_to_properties(hash),
          required: []
        }
      end

      def hash_to_properties(hash)
        hash.transform_values do |value|
          if value.is_a?(Hash)
            hash_to_json_schema(value)
          elsif value.is_a?(Class)
            { type: ruby_type_to_json_type(value.name) }
          else
            { type: ruby_type_to_json_type(value.class.name) }
          end
        end
      end

      def ruby_type_to_json_type(ruby_type)
        TYPE_MAPPING.fetch(ruby_type, 'string')
      end

      # Converts a status symbol or string to an integer.
      #
      # @param status [String, Symbol, nil] The status to convert.
      # @return [Integer] The status code as an integer.
      def status_to_integer(status)
        return 200 if status.nil?

        if status.to_s =~ /^\d+$/
          status.to_i
        else
          STATUS_SYMBOL_MAPPING.fetch(status.to_sym) do
            raise ArgumentError, "Unknown status symbol: #{status}"
          end
        end
      end

      # Converts a status code to its corresponding text description.
      #
      # @param status_code [Integer] The status code.
      # @return [String] The text description of the status code.
      def get_definition(status_code)
        HTTP_STATUS_DEFINITIONS[status_code] || "Definition not found for status code #{status_code}"
      end

      def class_to_symbol(klass)
        klass.name.underscore.to_sym
      end
    end
  end
end
