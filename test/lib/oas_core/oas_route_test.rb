# frozen_string_literal: true

require 'test_helper'

module OasCore
  class OasRouteTest < Minitest::Test
    def setup
      @route = build(:oas_route)
    end

    def test_extracts_path_parameters
      route = build(:oas_route, path: '/users/{user_id}/posts/{post_id}')
      assert_equal %w[user_id post_id], route.path_params
    end

    def test_excludes_format_from_path_parameters
      route = build(:oas_route, path: '/users/{user_id}.{format}')
      assert_equal %w[user_id format], route.path_params
    end

    def test_returns_all_tags_when_no_name_is_provided
      tags = [build(:parameter_tag), build(:request_body_tag)]
      route = build(:oas_route, tags: tags)

      assert_equal tags, route.tags
    end

    def test_filters_tags_by_name
      parameter_tag = build(:parameter_tag, tag_name: 'parameter')
      request_body_tag = build(:request_body_tag, tag_name: 'request_body')
      route = build(:oas_route, tags: [parameter_tag, request_body_tag])

      assert_equal [parameter_tag], route.tags('parameter')
      assert_equal [request_body_tag], route.tags('request_body')
    end
  end
end
