# frozen_string_literal: true

FactoryBot.define do
  factory :parameter_tag, class: 'OasCore::YARD::ParameterTag' do
    transient do
      tag_name { 'parameter' }
      name { 'example_param' }
      text { 'Example parameter description' }
      schema { { type: 'string', description: 'Example schema' }.to_json }
      location { 'query' }
      required { false }
    end

    initialize_with do
      new(tag_name, name, text, schema, location, required: required)
    end

    trait :required do
      required { true }
    end

    trait :path do
      location { 'path' }
    end

    trait :header do
      location { 'header' }
    end

    trait :cookie do
      location { 'cookie' }
    end
  end
end
