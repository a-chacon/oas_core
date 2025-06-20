# frozen_string_literal: true

FactoryBot.define do
  factory :request_body_example_tag, class: 'OasCore::YARD::RequestBodyExampleTag' do
    transient do
      tag_name { 'request_body_example' }
      text { 'Example request body example description' }
      content do
        {
          user: {
            name: 'John Doe',
            email: 'john@example.com',
            password: 'secure123'
          }
        }
      end
    end

    initialize_with do
      new(tag_name, text, content: content)
    end

    trait :with_json_content do
      content do
        {
          user: {
            name: 'Jane Doe',
            email: 'jane@example.com',
            age: 30,
            cars: [
              { identifier: 'ABC123' },
              { identifier: 'XYZ789' }
            ]
          }
        }
      end
    end

    trait :with_reference_content do
      content do
        build(:reference).ref
      end
    end
  end
end
