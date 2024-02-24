# frozen_string_literal: true

if Rails.env.development?
  Rails.application.configure do
    config.action_mailer.perform_deliveries = false
  end

  User.delete_all

  FactoryBot.create(:user, email: 'postman_user@test.com', password: 'P@ssw0rd!234')
end
