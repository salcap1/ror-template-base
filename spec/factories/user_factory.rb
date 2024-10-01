# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.unique.email }
    password { 'P@ssw0rd!234' }

    after(:build) do |user|
      create(:profile, user:)
    end

    trait :whitelisted do
      after(:create) do |user|
        create(:whitelisted_token, user:)
      end
    end

    trait :blacklisted do
      after(:create) do |user|
        create(:blacklisted_token, user:)
      end
    end

    trait :refreshed do
      after(:create) do |user|
        create(:refresh_token, user:)
      end
    end
  end
end
