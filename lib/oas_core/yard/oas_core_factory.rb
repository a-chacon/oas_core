# frozen_string_literal: true

module OasCore
  module YARD
    class TagParsingError < StandardError; end

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
      rescue StandardError => e
        raise TagParsingError, "Failed to parse request body tag: #{e.message}"
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
      rescue StandardError => e
        raise TagParsingError, "Failed to parse request body example tag: #{e.message}"
      end

      # Parses a tag that represents a parameter.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ParameterTag] The parsed parameter tag object.
      def parse_tag_with_parameter(tag_name, text)
        match = text.squish.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        if match
          first = match[1]
          second = match[2]
          description = match[3]
        end
        name, location = text_and_last_parenthesis_content(first)
        raw_type, required = text_and_required(second)
        schema = raw_type_to_content(raw_type)
        name = "#{name}[]" if location == 'query' && schema[:type] == 'array'

        ParameterTag.new(tag_name, name, description.strip, schema, location, required:)
      rescue StandardError => e
        raise TagParsingError, "Failed to parse parameter tag: #{e.message}"
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
      rescue StandardError => e
        raise TagParsingError, "Failed to parse response tag: #{e.message}"
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
      rescue StandardError => e
        raise TagParsingError, "Failed to parse response example tag: #{e.message}"
      end

      # Parses a tag that represents a parameter reference.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ParameterReferenceTag] The parsed parameter reference tag object.
      def parse_tag_with_parameter_reference(tag_name, text)
        ref = text.strip
        reference = OasCore::Spec::Reference.new(ref)
        ParameterReferenceTag.new(tag_name, reference)
      rescue StandardError => e
        raise TagParsingError, "Failed to parse parameter reference tag: #{e.message}"
      end

      # Parses a tag that represents a request body reference.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [RequestBodyReferenceTag] The parsed request body reference tag object.
      def parse_tag_with_request_body_reference(tag_name, text)
        ref = text.strip
        reference = OasCore::Spec::Reference.new(ref)
        RequestBodyReferenceTag.new(tag_name, reference)
      rescue StandardError => e
        raise TagParsingError, "Failed to parse request body reference tag: #{e.message}"
      end

      # Parses a tag that represents a response reference.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ResponseReferenceTag] The parsed response reference tag object.
      def parse_tag_with_response_reference(tag_name, text)
        ref = text.strip
        reference = OasCore::Spec::Reference.new(ref)
        ResponseReferenceTag.new(tag_name, reference)
      rescue StandardError => e
        raise TagParsingError, "Failed to parse response reference tag: #{e.message}"
      end

      private

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

      # Splits the text into description with detail and type parts.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the description with detail and the type.
      def split_description_and_type(text)
        match = text.match(/^(.*?)\s*\[(.*?)\]$/)
        raise TagParsingError, "Invalid format: #{text}" if match.nil?

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
