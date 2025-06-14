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
end
