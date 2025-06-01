# frozen_string_literal: true

require 'test_helper'

module OasCore
  class OasRouteTest < Minitest::Test
    # setup do
    #   @route = build(:oas_route)
    # end
    #
    # test 'initializes with attributes' do
    #   attributes = {
    #     controller_class: 'TestController',
    #     controller_action: 'show',
    #     path: '/test/:id'
    #   }
    #   route = OasRoute.new(attributes)
    #
    #   assert_equal 'TestController', route.controller_class
    #   assert_equal 'show', route.controller_action
    #   assert_equal '/test/:id', route.path
    # end
    #
    # test 'extracts path parameters' do
    #   route = build(:oas_route, path: '/users/:user_id/posts/:post_id')
    #   assert_equal %w[user_id post_id], route.path_params
    # end
    #
    # test 'excludes format from path parameters' do
    #   route = build(:oas_route, path: '/users/:user_id.:format')
    #   assert_equal ['user_id'], route.path_params
    # end
    #
    # test 'returns all tags when no name is provided' do
    #   tags = [build(:parameter_tag), build(:request_body_tag)]
    #   route = build(:oas_route, tags: tags)
    #
    #   assert_equal tags, route.tags
    # end
    #
    # test 'filters tags by name' do
    #   parameter_tag = build(:parameter_tag, tag_name: 'parameter')
    #   request_body_tag = build(:request_body_tag, tag_name: 'request_body')
    #   route = build(:oas_route, tags: [parameter_tag, request_body_tag])
    #
    #   assert_equal [parameter_tag], route.tags('parameter')
    #   assert_equal [request_body_tag], route.tags('request_body')
    # end
  end
end
