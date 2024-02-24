# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.shared_context 'with issued tokens' do
  let!(:new_access_token) { Faker::Internet.device_token }
  let!(:new_refresh_token) { Faker::Internet.device_token }

  before do
    allow(Auth::Issuer)
      .to receive(:issue!)
      .and_return([new_access_token, new_refresh_token])
  end
end
