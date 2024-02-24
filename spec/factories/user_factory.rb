# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username }
    password { 'P@ssw0rd!234' }

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
