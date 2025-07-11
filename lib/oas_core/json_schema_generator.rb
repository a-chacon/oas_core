# frozen_string_literal: true

require 'json'

module OasCore
  # The JsonSchemaGenerator module provides methods to transform string representations
  # of data types into JSON schema formats.
  module JsonSchemaGenerator
    @custom_type_parsers = {}

    # Registers a custom type parser.
    #
    # @param type_matcher [Proc] A proc that matches the type string.
    # @param parser [Proc] A proc that processes the type string.
    def self.register_type_parser(type_matcher, parser)
      @custom_type_parsers[type_matcher] = parser
    end

    # Processes a string representing a data type and converts it into a JSON schema.
    #
    # @param str [String] The string representation of a data type.
    # @return [Hash] A hash containing the required flag and the JSON schema.
    def self.process_string(str)
      parsed = parse_type(str)
      {
        required: parsed[:required],
        json_schema: to_json_schema(parsed)
      }
    end

    # Parses a string representing a data type and determines its JSON schema type.
    #
    # @param str [String] The string representation of a data type.
    # @return [Hash] A hash containing the type, whether it's required, and any additional properties.
    # Registry for custom type parsers
    def self.parse_type(str)
      required = str.start_with?('!')
      type = str.sub(/^!/, '').strip

      case type
      when /^Hash\{(.+)\}$/i
        { type: :object, required:, properties: parse_object_properties(::Regexp.last_match(1)) }
      when /^Array<(.+)>$/i
        { type: :array, required:, items: parse_type(::Regexp.last_match(1)) }
      else
        custom_parser = @custom_type_parsers.find { |matcher, _| matcher.call(type) }
        if custom_parser
          custom_parser.last.call(type, required)
        else
          { type: type.downcase.to_sym, required: }
        end
      end
    end

    # rubocop:disable Metrics
    # Parses the properties of an object type from a string.
    #
    # @param str [String] The string representation of the object's properties.
    # @return [Hash] A hash where keys are property names and values are their JSON schema types.
    def self.parse_object_properties(str)
      properties = {}
      stack = []
      current_key = ''
      current_value = ''

      str.each_char.with_index do |char, index|
        case char
        when '{', '<'
          stack.push(char)
          current_value += char
        when '}', '>'
          stack.pop
          current_value += char
        when ','
          if stack.empty?
            properties[current_key.strip.to_sym] = parse_type(current_value.strip)
            current_key = ''
            current_value = ''
          else
            current_value += char
          end
        when ':'
          if stack.empty?
            current_key = current_value
            current_value = ''
          else
            current_value += char
          end
        else
          current_value += char
        end

        if index == str.length - 1 && !current_key.empty?
          properties[current_key.strip.to_sym] =
            parse_type(current_value.strip)
        end
      end

      properties
    end
    # rubocop:enable Metrics

    # Converts a parsed data type into a JSON schema format.
    #
    # @param parsed [Hash] The parsed data type hash.
    # @return [Hash] The JSON schema representation of the parsed data type.
    def self.to_json_schema(parsed)
      case parsed[:type]
      when :object
        schema = {
          type: 'object',
          properties: {}
        }
        required_props = []
        parsed[:properties].each do |key, value|
          schema[:properties][key] = to_json_schema(value)
          required_props << key.to_s if value[:required]
        end
        schema[:required] = required_props unless required_props.empty?
        schema
      when :array
        {
          type: 'array',
          items: to_json_schema(parsed[:items])
        }
      when nil
        parsed
      else
        ruby_type_to_json_schema_type(parsed[:type])
      end
    end

    # rubocop:disable Metrics
    # Converts a Ruby data type into its corresponding JSON schema type.
    #
    # @param type [Symbol, String] The Ruby data type.
    # @return [Hash, String] The JSON schema type or a hash with additional format information.
    def self.ruby_type_to_json_schema_type(type)
      case type.to_s.downcase
      when 'string' then { type: 'string' }
      when 'integer' then { type: 'integer' }
      when 'float' then { type: 'float' }
      when 'boolean' then { type: 'boolean' }
      when 'array' then { type: 'array' }
      when 'hash' then { type: 'hash' }
      when 'nil' then { type: 'null' }
      when 'date' then { type: 'string', format: 'date' }
      when 'datetime' then { type: 'string', format: 'date-time' }
      when 'file' then { type: 'string', format: 'binary' }
      else type.to_s.downcase
      end
    end
    # rubocop:enable Metrics
  end
end
