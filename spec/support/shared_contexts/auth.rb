# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.shared_context 'with cookie jar' do
  let!(:cookies) { ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:cookies)
      .and_return(cookies)
  end
end

RSpec.shared_context 'with authenticated user' do
  include_context 'with cookie jar'

  let!(:user) { create(:user, :whitelisted) }
  let!(:decoded_token) { Faker::Internet.device_token }
  let!(:access_token) { Faker::Internet.device_token }
  let!(:refresh_token) { Faker::Internet.device_token }

  before do
    cookies.signed[:access_token] = access_token
    cookies.signed[:refresh_token] = refresh_token

    allow(Auth::Authenticator)
      .to receive(:authenticate!)
      .with(access_token:)
      .and_return([user, decoded_token])
  end
end
