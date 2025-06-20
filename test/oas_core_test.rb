# frozen_string_literal: true

require 'test_helper'

class OasCoreTest < Minitest::Test
  def test_it_has_a_version_number
    assert OasCore::VERSION
  end

  def test_oas_route_factory
    route = build(:oas_route)
    assert_equal 'get', route.verb
  end

  def test_build_merges_oas_specification
    oas_routes = [build(:oas_route)]
    oas_source = { info: { title: 'Existing API' } }

    result = OasCore.build(oas_routes, oas_source: oas_source)

    assert_includes result.keys, :info
    assert_includes result.keys, :paths
    assert_equal 'Existing API', result.dig(:info, :title)
  end

  def test_build_merges_components
    oas_routes = [build(:oas_route)]

    components = {
      schemas: {
        'new_schema' => {
          type: 'object',
          properties: {
            id: { type: 'string' },
            name: { type: 'string' }
          },
          required: ['id']
        }
      },
      responses: {
        'new_response' => {
          description: 'A new response',
          content: {
            'application/json' => {
              schema: { type: 'object' }
            }
          }
        }
      },
      parameters: {
        'new_parameter' => {
          name: 'id',
          in: 'path',
          required: true,
          schema: { type: 'string' }
        }
      },
      security_schemes: {
        'new_scheme' => {
          type: 'apiKey',
          name: 'api_key',
          in: 'header'
        }
      }
    }

    result = OasCore.build(oas_routes, oas_source: { components: components })

    assert_includes result.dig(:components, :schemas).keys, 'new_schema'
    assert_equal 'object', result.dig(:components, :schemas, 'new_schema', :type)
    assert_equal ['id'], result.dig(:components, :schemas, 'new_schema', :required)

    assert_includes result.dig(:components, :responses).keys, 'new_response'
    assert_equal 'A new response', result.dig(:components, :responses, 'new_response', :description)

    assert_includes result.dig(:components, :parameters).keys, 'new_parameter'
    assert_equal 'path', result.dig(:components, :parameters, 'new_parameter', :in)

    assert_includes result.dig(:components, :security_schemes).keys, 'new_scheme'
    assert_equal 'apiKey', result.dig(:components, :security_schemes, 'new_scheme', :type)
  end
end
