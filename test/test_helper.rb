# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'oas_core'

require 'minitest/autorun'
require 'factory_bot'
require 'debug'
require 'minitest/reporters'
require 'minitest/mock'

Minitest::Reporters.use!

module Minitest
  class Test
    include FactoryBot::Syntax::Methods
  end
end

FactoryBot.find_definitions
