# frozen_string_literal: true

FactoryBot.define do
  factory :reference, class: 'OasCore::Spec::Reference' do
    ref { '#/components/schemas/Example' }

    initialize_with do
      new(ref)
    end

    trait :with_custom_ref do
      ref { '#/components/schemas/Custom' }
    end
  end
end
