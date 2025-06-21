# frozen_string_literal: true

FactoryBot.define do
  factory :request_body_reference_tag, class: 'OasCore::YARD::RequestBodyReferenceTag' do
    transient do
      tag_name { 'request_body_ref' }
      reference { build(:reference) }
    end

    initialize_with do
      new(tag_name, reference)
    end
  end
end
