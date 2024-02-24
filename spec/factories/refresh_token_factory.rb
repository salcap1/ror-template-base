# frozen_string_literal: true

FactoryBot.define do
  factory :refresh_token do
    user

    access_token_jti { 'MyString' }
    exp { Time.now.utc + Auth::Expiry.refresh_token_span }
  end
end
