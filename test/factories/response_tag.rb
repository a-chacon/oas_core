# frozen_string_literal: true

FactoryBot.define do
  factory :response_tag, class: 'OasCore::YARD::ResponseTag' do
    transient do
      tag_name { 'response' }
      name { '404' }
      text { 'User not found by the provided Id' }
      schema do
        {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            message: { type: 'string' }
          },
          required: %w[success message]
        }
      end
    end

    initialize_with do
      new(tag_name, name, text, schema)
    end

    trait :validation_errors do
      name { '422' }
      text { 'Validation errors' }
      schema do
        {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            errors: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  field: { type: 'string' },
                  type: { type: 'string' },
                  detail: {
                    type: 'array',
                    items: { type: 'string' }
                  }
                },
                required: %w[field type detail]
              }
            }
          },
          required: %w[success errors]
        }
      end
    end

    trait :test_response do
      name { '405' }
      text { 'A test response from an Issue' }
      schema do
        {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              message: { type: 'string' },
              data: {
                type: 'object',
                properties: {
                  availabilities: {
                    type: 'array',
                    items: { type: 'string' }
                  },
                  dates: {
                    type: 'array',
                    items: { type: 'string', format: 'date' }
                  }
                },
                required: %w[availabilities dates]
              }
            },
            required: %w[message data]
          }
        }
      end
    end
  end
end
