# frozen_string_literal: true

FactoryBot.define do
  factory :oas_route, class: 'OasCore::OasRoute' do
    controller { 'ExampleController' }
    method_name { 'show' }
    verb { 'get' }
    path { '/example/:id' }
    docstring { 'Example docstring' }
    source_string { 'Example source string' }
    tags { [] }
  end
end
