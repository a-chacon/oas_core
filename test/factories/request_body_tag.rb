# frozen_string_literal: true

FactoryBot.define do
  factory :request_body_tag, class: 'OasCore::YARD::RequestBodyTag' do
    transient do
      tag_name { 'request_body' }
      text { 'Example request body description' }
      content { { type: 'object', properties: { name: { type: 'string' } } }.to_json }
      required { false }
    end

    initialize_with do
      new(tag_name, text, content: content, required: required)
    end

    trait :required do
      required { true }
    end

    trait :with_complex_schema do
      content do
        {
          type: 'object',
          properties: {
            user: {
              type: 'object',
              properties: {
                name: { type: 'string' },
                email: { type: 'string' },
                age: { type: 'integer' },
                cars: {
                  type: 'array',
                  items: {
                    type: 'object',
                    properties: {
                      identifier: { type: 'string' }
                    }
                  }
                }
              }
            }
          }
        }.to_json
      end
    end
  end
end
