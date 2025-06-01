# frozen_string_literal: true

FactoryBot.define do
  factory :oas_route, class: 'OasCore::OasRoute' do
    controller_class { 'ExampleController' }
    controller_action { 'index' }
    controller { 'ExampleController' }
    controller_path { '/example' }
    method_name { 'GET' }
    verb { 'get' }
    path { '/example/:id' }
    docstring { 'Example docstring' }
    source_string { 'Example source string' }
    tags { [] }
  end
end
