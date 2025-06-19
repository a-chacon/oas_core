# frozen_string_literal: true

module OasCore
  module YARD
    class OasCoreFactory < ::YARD::Tags::DefaultFactory
      # Parses a tag that represents a request body.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [RequestBodyTag] The parsed request body tag object.
      def parse_tag_with_request_body(tag_name, text)
        description, raw_type = split_description_and_type(text.squish)
        description, content_type = text_and_last_parenthesis_content(description)
        raw_type, required = text_and_required(raw_type)
        content = raw_type_to_content(raw_type)

        RequestBodyTag.new(tag_name, description, content:, required:, content_type:)
      end

      # Parses a tag that represents a request body example.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [RequestBodyExampleTag] The parsed request body example tag object.
      def parse_tag_with_request_body_example(tag_name, text)
        description, raw_type = split_description_and_type(text.squish)
        raw_type, = text_and_required(raw_type)
        content = raw_type_to_content(raw_type)

        RequestBodyExampleTag.new(tag_name, description, content: content)
      end

      # Parses a tag that represents a parameter.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ParameterTag] The parsed parameter tag object.
      def parse_tag_with_parameter(tag_name, text)
        name, location, schema, required, description = extract_name_location_schema_and_description(text.squish)
        name = "#{name}[]" if location == 'query' && schema[:type] == 'array'
        ParameterTag.new(tag_name, name, description, schema, location, required:)
      end

      # Parses a tag that represents a response.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ResponseTag] The parsed response tag object.
      def parse_tag_with_response(tag_name, text)
        description, raw_type = split_description_and_type(text.squish)
        description, code = text_and_last_parenthesis_content(description)
        content = raw_type_to_content(raw_type)

        ResponseTag.new(tag_name, description, code, content)
      end

      # Parses a tag that represents a response example.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ResponseExampleTag] The parsed response example tag object.
      def parse_tag_with_response_example(tag_name, text)
        description, raw_type = split_description_and_type(text.squish)
        description, code = text_and_last_parenthesis_content(description)
        content = raw_type_to_content(raw_type)

        ResponseExampleTag.new(tag_name, description, content: content, code:)
      end

      private

      # Reusable method for extracting description, type, and content with an option to process content.
      # @param text [String] The text to parse.
      # @param process_content [Boolean] Whether to evaluate the content as a hash.
      # @return [Array] An array containing the description, type, and content or remaining text.
      def extract_description_type_and_content(text, process_content: false, expresion: /^(.*?)\s*\[(.*)\]\s*(.*)$/)
        match = text.match(expresion)
        raise ArgumentError, "Invalid tag format: #{text}" if match.nil?

        description = match[1].strip
        type = match[2].strip
        content = process_content ? eval_content(match[3].strip) : match[3].strip

        [description, type, content]
      end

      # Specific method to extract description and schema for request body tags.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the description, class, schema, required flag and content type.
      def extract_description_and_schema(text)
        description, type, = extract_description_type_and_content(text)
        description, content_type = extract_text_and_parentheses_content(description)

        klass, schema, required = type_text_to_schema(type)
        [description, klass, schema, required, content_type]
      end

      # Specific method to extract name, location, and schema for parameters.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the name, location, schema, and required flag.
      def extract_name_location_schema_and_description(text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        name, location = extract_text_and_parentheses_content(match[1].strip)
        schema, required = type_text_to_schema(match[2].strip)[1..]
        description = match[3].strip
        [name, location, schema, required, description]
      end

      # Specific method to extract name, code, and schema for responses.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the name, code, and schema.
      def extract_name_code_and_schema(text)
        name, code = extract_text_and_parentheses_content(text)
        _, type, = extract_description_type_and_content(text)
        schema = type_text_to_schema(type)[1]
        [name, code, schema]
      end

      # Specific method to extract name, code, and hash for responses examples.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the name, code, and schema.
      def extract_name_code_and_hash(text)
        name, code = extract_text_and_parentheses_content(text)
        _, _, content = extract_description_type_and_content(text, expresion: /^(.*?)\[([^\]]*)\](.*)$/m)
        hash = eval_content(content)
        [name, code, hash]
      end

      # Evaluates a string as a hash, handling errors gracefully.
      # @param content [String] The content string to evaluate.
      # @return [Hash] The evaluated hash, or an empty hash if an error occurs.
      # rubocop:disable Security/Eval
      def eval_content(content)
        eval(content)
      rescue StandardError
        {}
      end
      # rubocop:enable Security/Eval

      # Converts raw_type to content based on its format.
      # @param raw_type [String] The raw type string to process.
      # @return [Hash] The processed content.
      def raw_type_to_content(raw_type)
        if raw_type.start_with?('JSON')
          json_string = raw_type.sub(/^JSON/, '').gsub(/'/, '"')
          JSON.parse(json_string)
        elsif raw_type.start_with?('Reference:')
          ref = raw_type.sub(/^Reference:/, '').strip
          OasCore::Spec::Reference.new(ref)
        else
          JsonSchemaGenerator.process_string(raw_type)[:json_schema]
        end
      rescue JSON::ParserError
        {}
      end

      # Parses the position name and location from input text.
      # @param input [String] The input text to parse.
      # @return [Array] An array containing the name and location.
      def extract_text_and_parentheses_content(input)
        return input unless input =~ /^(.+?)\(([^)]+)\)/

        text = ::Regexp.last_match(1).strip
        parenthesis_content = ::Regexp.last_match(2).strip
        [text, parenthesis_content]
      end

      # Extracts the text and whether it's required.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the text and a required flag.
      def text_and_required(text)
        if text.start_with?('!')
          [text.sub(/^!/, ''), true]
        else
          [text, false]
        end
      end

      # Matches and validates a description and type from text.
      # @param text [String] The text to parse.
      # @return [MatchData] The match data from the regex.
      def description_and_type(text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        raise ArgumentError, "The request body tag is not valid: #{text}" if match.nil?

        match
      end

      # Converts type text to a schema, checking if it's an ActiveRecord class.
      # @param text [String] The type text to convert.
      # @return [Array] An array containing the class, schema, and required flag.
      def type_text_to_schema(text)
        type_text, required = text_and_required(text)

        schema = JsonSchemaGenerator.process_string(type_text)[:json_schema]
        klass = Object

        [klass, schema, required]
      end

      # Splits the text into description with detail and type parts.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the description with detail and the type.
      def split_description_and_type(text)
        match = text.match(/^(.*?)\s*\[(.*?)\]$/)
        raise ArgumentError, "Invalid format: #{text}" if match.nil?

        [match[1].strip, match[2].strip]
      end

      # Extracts the description and the detail (content of the last parentheses) from the text.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the description and the detail.
      def text_and_last_parenthesis_content(text)
        # Find the last occurrence of parentheses
        last_open = text.rindex('(')
        last_close = text.rindex(')')

        if last_open && last_close && last_open < last_close
          description = text[0...last_open].strip
          detail = text[(last_open + 1)...last_close].strip
          [description, detail]
        else
          [text.strip, nil]
        end
      end
    end
  end
end
