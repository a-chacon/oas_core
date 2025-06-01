# frozen_string_literal: true

FactoryBot.define do
  factory :response_example_tag, class: 'OasCore::YARD::ResponseExampleTag' do
    transient do
      tag_name { 'response_example' }
      text { 'Example response' }
      code { 200 }
      content do
        {
          success: true,
          message: 'Success message'
        }
      end
    end

    initialize_with do
      new(tag_name, text, content: content, code: code)
    end

    trait :not_found do
      code { 404 }
      text { 'User not found by the provided Id' }
      content do
        {
          success: false,
          message: 'User not found by the provided Id'
        }
      end
    end

    trait :validation_errors do
      code { 422 }
      text { 'Validation errors' }
      content do
        {
          success: false,
          errors: [
            {
              field: 'email',
              type: 'invalid',
              detail: ['Invalid email format']
            }
          ]
        }
      end
    end

    trait :test_response do
      code { 405 }
      text { 'A test response from an Issue' }
      content do
        [
          {
            message: 'Test message',
            data: {
              availabilities: %w[available unavailable],
              dates: %w[2025-01-01 2025-01-02]
            }
          }
        ]
      end
    end
  end
end
