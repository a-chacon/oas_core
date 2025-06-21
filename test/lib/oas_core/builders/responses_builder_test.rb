# frozen_string_literal: true

require 'test_helper'

module OasCore
  module Builders
    class ResponsesBuilderTest < Minitest::Test
      #   def setup
      #     @specification = double('Specification')
      #     @content_builder = double('ContentBuilder')
      #     @response_builder = double('ResponseBuilder')
      #     @json_schema_generator = double('JsonSchemaGenerator')
      #     @utils = double('Utils')
      #
      #     @responses_builder = ResponsesBuilder.new(
      #       @specification,
      #       content_builder: @content_builder,
      #       response_builder: @response_builder,
      #       json_schema_generator: @json_schema_generator,
      #       utils: @utils
      #     )
      #   end
      #
      #   def test_from_oas_route_with_response_tags
      #     response_tag = FactoryBot.build(:response_tag)
      #     response_example_tag = FactoryBot.build(:response_example_tag, code: response_tag.name)
      #
      #     oas_route = FactoryBot.build(:oas_route, tags: [response_tag, response_example_tag])
      #
      #     allow(@content_builder).to receive(:new).with(@specification).and_return(@content_builder)
      #     allow(@content_builder).to receive(:with_schema).with(response_tag.schema).and_return(@content_builder)
      #     allow(@content_builder).to receive(:with_examples_from_tags).with([response_example_tag]).and_return(@content_builder)
      #     allow(@content_builder).to receive(:build).and_return('content')
      #
      #     allow(@response_builder).to receive(:new).with(@specification).and_return(@response_builder)
      #     allow(@response_builder).to receive(:with_code).with(response_tag.name.to_i).and_return(@response_builder)
      #     allow(@response_builder).to receive(:with_description).with(response_tag.text).and_return(@response_builder)
      #     allow(@response_builder).to receive(:with_content).with('content').and_return(@response_builder)
      #     allow(@response_builder).to receive(:build).and_return('response')
      #
      #     result = @responses_builder.from_oas_route(oas_route)
      #     assert_equal @responses_builder, result
      #   end
      #
      #   def test_from_oas_route_with_response_ref_tags
      #     ref_tag = FactoryBot.build(:parameter_reference_tag, tag_name: 'response_ref', reference: FactoryBot.build(:reference))
      #
      #     oas_route = FactoryBot.build(:oas_route, tags: [ref_tag])
      #
      #     result = @responses_builder.from_oas_route(oas_route)
      #     assert_equal @responses_builder, result
      #   end
      #
      #   def test_add_default_responses_with_security
      #     oas_route = FactoryBot.build(:oas_route, method_name: 'show')
      #     security = true
      #
      #     allow(@utils).to receive(:status_to_integer).with(:unauthorized).and_return(401)
      #     allow(@utils).to receive(:status_to_integer).with(:forbidden).and_return(403)
      #     allow(@utils).to receive(:status_to_integer).with(:internal_server_error).and_return(500)
      #     allow(@utils).to receive(:status_to_integer).with(:not_found).and_return(404)
      #     allow(@utils).to receive(:get_definition).with(401).and_return('Unauthorized')
      #     allow(@utils).to receive(:get_definition).with(403).and_return('Forbidden')
      #     allow(@utils).to receive(:get_definition).with(500).and_return('Internal Server Error')
      #     allow(@utils).to receive(:get_definition).with(404).and_return('Not Found')
      #
      #     allow(@json_schema_generator).to receive(:process_string).with(String).and_return({ json_schema: 'schema' })
      #
      #     allow(@content_builder).to receive(:new).with(@specification).and_return(@content_builder)
      #     allow(@content_builder).to receive(:with_schema).with('schema').and_return(@content_builder)
      #     allow(@content_builder).to receive(:build).and_return('content')
      #
      #     allow(@response_builder).to receive(:new).with(@specification).and_return(@response_builder)
      #     allow(@response_builder).to receive(:with_code).with(401).and_return(@response_builder)
      #     allow(@response_builder).to receive(:with_description).with('Unauthorized').and_return(@response_builder)
      #     allow(@response_builder).to receive(:with_content).with('content').and_return(@response_builder)
      #     allow(@response_builder).to receive(:build).and_return('response')
      #
      #     result = @responses_builder.add_default_responses(oas_route, security)
      #     assert_equal @responses_builder, result
      #   end
      #
      #   def test_build
      #     responses = Minitest::Mock.new
      #     @responses_builder.instance_variable_set(:@responses, responses)
      #
      #     result = @responses_builder.build
      #     assert_equal responses, result
      #   end
    end
  end
end
