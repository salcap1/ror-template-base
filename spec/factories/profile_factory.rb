# frozen_string_literal: true

FactoryBot.define do
  factory :profile, class: 'Profile' do
    user

    username { Faker::Internet.unique.username }

    after(:build) do |profile|
      file_path = Rails.root.join('spec/fixtures/files/avatar.jpg')
      profile.avatar.attach(io: File.open(file_path), filename: 'avatar.jpg', content_type: 'image/jpeg')
    end
  end
end
