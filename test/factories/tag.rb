# frozen_string_literal: true

FactoryBot.define do
  factory :tag, class: '::YARD::Tags::Tag' do
    transient do
      tag_name { 'tag' }
      text { 'Example tag description' }
    end

    initialize_with do
      new(tag_name, text)
    end

    trait :summary do
      tag_name { 'summary' }
      text { 'Example summary description' }
    end

    trait :tags do
      tag_name { 'tags' }
      text { 'example_tag, another_tag' }
    end

    trait :no_auth do
      tag_name { 'no_auth' }
      text { '' }
    end

    trait :auth do
      tag_name { 'auth' }
      text { 'api_key, oauth2' }
    end
  end
end
