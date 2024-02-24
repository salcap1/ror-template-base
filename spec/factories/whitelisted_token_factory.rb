# frozen_string_literal: true

FactoryBot.define do
  factory :whitelisted_token do
    user

    jti { Faker::Internet.device_token }
    exp { Time.now.utc + Auth::Expiry.access_token_span }
  end
end
