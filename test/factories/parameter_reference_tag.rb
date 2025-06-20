# frozen_string_literal: true

FactoryBot.define do
  factory :parameter_reference_tag, class: 'OasCore::YARD::ParameterReferenceTag' do
    transient do
      tag_name { 'parameter_ref' }
      reference { build(:reference) }
    end

    initialize_with do
      new(tag_name, reference)
    end
  end
end
