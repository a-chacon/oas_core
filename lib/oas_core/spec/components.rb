# frozen_string_literal: true

module OasCore
  module Spec
    class Components
      include Specable

      attr_accessor :schemas, :parameters, :security_schemes, :request_bodies, :responses, :headers, :examples, :links,
                    :callbacks

      def initialize(specification)
        @specification = specification
        @schemas = {}
        @parameters = {}
        @security_schemes = OasCore.config.security_schemas
        @request_bodies = {}
        @responses = {}
        @headers = {}
        @examples = {}
        @links = {}
        @callbacks = {}
      end

      def to_spec
        {
          schemas: @schemas,
          responses: @responses.transform_values(&:to_spec),
          parameters: @parameters.transform_values(&:to_spec),
          request_bodies: @request_bodies.transform_values(&:to_spec),
          security_schemes: @security_schemes,
          headers: @headers.transform_values(&:to_spec),
          examples: @examples,
          links: @links.transform_values(&:to_spec),
          callbacks: @callbacks.transform_values(&:to_spec)
        }.compact
      end

      def add_response(response)
        key = response.hash_key
        @responses[key] = response unless @responses.key? key

        response_reference(key)
      end

      def add_parameter(parameter)
        key = parameter.hash_key
        @parameters[key] = parameter unless @parameters.key? key

        parameter_reference(key)
      end

      def add_request_body(request_body)
        key = request_body.hash_key
        @request_bodies[key] = request_body unless @request_bodies.key? key

        request_body_reference(key)
      end

      def add_schema(schema)
        key = nil
        if OasCore.config.use_model_names
          if schema[:type] == 'array'
            arr_schema = schema[:items]
            arr_key = arr_schema['title']
            key = "#{arr_key}List" unless arr_key.nil?
          else
            key = schema['title']
          end
        end

        key = Hashable.generate_hash(schema) if key.nil?

        @schemas[key] = schema if @schemas[key].nil?
        schema_reference(key)
      end

      def add_example(example)
        key = Hashable.generate_hash(example)
        @examples[key] = example if @examples[key].nil?

        example_reference(key)
      end

      def create_reference(type, name)
        "#/components/#{type}/#{name}"
      end

      def schema_reference(name)
        Reference.new(create_reference('schemas', name))
      end

      def response_reference(name)
        Reference.new(create_reference('responses', name))
      end

      def parameter_reference(name)
        Reference.new(create_reference('parameters', name))
      end

      def example_reference(name)
        Reference.new(create_reference('examples', name))
      end

      def request_body_reference(name)
        Reference.new(create_reference('requestBodies', name))
      end
    end
  end
end
