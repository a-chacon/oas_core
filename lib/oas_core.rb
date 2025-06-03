# frozen_string_literal: true

require 'yard'
require 'method_source'
require 'oas_core/string'

module OasCore
  require 'oas_core/version'

  autoload :Configuration, 'oas_core/configuration'
  autoload :OasRoute, 'oas_core/oas_route'
  autoload :Utils, 'oas_core/utils'
  autoload :JsonSchemaGenerator, 'oas_core/json_schema_generator'

  module Builders
    autoload :OperationBuilder, 'oas_core/builders/operation_builder'
    autoload :PathItemBuilder, 'oas_core/builders/path_item_builder'
    autoload :ResponseBuilder, 'oas_core/builders/response_builder'
    autoload :ResponsesBuilder, 'oas_core/builders/responses_builder'
    autoload :ContentBuilder, 'oas_core/builders/content_builder'
    autoload :ParametersBuilder, 'oas_core/builders/parameters_builder'
    autoload :ParameterBuilder, 'oas_core/builders/parameter_builder'
    autoload :RequestBodyBuilder, 'oas_core/builders/request_body_builder'
    autoload :OasRouteBuilder, 'oas_core/builders/oas_route_builder'
    autoload :SpecificationBuilder, 'oas_core/builders/specification_builder'
  end

  module Spec
    autoload :Hashable, 'oas_core/spec/hashable'
    autoload :Specable, 'oas_core/spec/specable'
    autoload :Components, 'oas_core/spec/components'
    autoload :Parameter, 'oas_core/spec/parameter'
    autoload :License, 'oas_core/spec/license'
    autoload :Response, 'oas_core/spec/response'
    autoload :PathItem, 'oas_core/spec/path_item'
    autoload :Operation, 'oas_core/spec/operation'
    autoload :RequestBody, 'oas_core/spec/request_body'
    autoload :Responses, 'oas_core/spec/responses'
    autoload :MediaType, 'oas_core/spec/media_type'
    autoload :Paths, 'oas_core/spec/paths'
    autoload :Contact, 'oas_core/spec/contact'
    autoload :Info, 'oas_core/spec/info'
    autoload :Server, 'oas_core/spec/server'
    autoload :Tag, 'oas_core/spec/tag'
    autoload :Specification, 'oas_core/spec/specification'
    autoload :Reference, 'oas_core/spec/reference'
  end

  module YARD
    autoload :RequestBodyTag, 'oas_core/yard/request_body_tag'
    autoload :ExampleTag, 'oas_core/yard/example_tag'
    autoload :RequestBodyExampleTag, 'oas_core/yard/request_body_example_tag'
    autoload :ParameterTag, 'oas_core/yard/parameter_tag'
    autoload :ResponseTag, 'oas_core/yard/response_tag'
    autoload :ResponseExampleTag, 'oas_core/yard/response_example_tag'
    autoload :OasCoreFactory, 'oas_core/yard/oas_core_factory'
  end

  class << self
    def config=(config)
      raise 'Configuration must be an OasCore::Configuration or its subclass' unless config.is_a?(OasCore::Configuration)

      @config = config
    end

    def config
      @config ||= Configuration.new
    end

    def configure_yard!
      ::YARD::Tags::Library.default_factory = YARD::OasCoreFactory
      yard_tags = {
        'Request body' => %i[request_body with_request_body],
        'Request body Example' => %i[request_body_example with_request_body_example],
        'Parameter' => %i[parameter with_parameter],
        'Response' => %i[response with_response],
        'Response Example' => %i[response_example with_response_example],
        'Endpoint Tags' => [:tags],
        'Summary' => [:summary],
        'No Auth' => [:no_auth],
        'Auth methods' => %i[auth with_types],
        'OAS Include' => [:oas_include]
      }
      yard_tags.each do |tag_name, (method_name, handler)|
        ::YARD::Tags::Library.define_tag(tag_name, method_name, handler)
      end
    end
  end
end
