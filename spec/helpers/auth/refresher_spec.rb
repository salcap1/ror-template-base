# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Refresher do
  describe '#authenticate!' do
    let!(:refresher) { subject }

    let(:user) { create(:user) }
    let(:access_token) { Faker::Internet.device_token }
    let(:refresh_token) { Faker::Internet.device_token }
    let(:decoded_token) { { jti: Faker::Internet.device_token, exp: Time.now.utc, user_id: user.id } }

    describe 'success' do
      include_context 'with issued tokens'

      let!(:refresh_token) do
        create(:refresh_token, user:, access_token_jti: decoded_token[:jti])
      end

      it 'returns user & token' do
        expect(refresher.refresh!(refresh_token:, decoded_token:, user:)).to eq([new_access_token, new_refresh_token])
        expect(RefreshToken.find_by(access_token_jti: decoded_token[:jti])).to be_nil
      end
    end

    describe 'failure' do
      it 'refresh_token is invalid' do
        expect do
          refresher.refresh!(refresh_token: nil, decoded_token:, user:)
        end.to raise_error(Auth::Errors::RefreshError, 'Missing arguments.')
      end

      it 'decoded_token is invalid' do
        expect do
          refresher.refresh!(refresh_token:, decoded_token: nil, user:)
        end.to raise_error(Auth::Errors::RefreshError, 'Missing arguments.')
      end

      it 'user is invalid' do
        expect do
          refresher.refresh!(refresh_token:, decoded_token:, user: nil)
        end.to raise_error(Auth::Errors::RefreshError, 'Missing arguments.')
      end

      it 'refresh_token does not exist' do
        expect do
          refresher.refresh!(refresh_token:, decoded_token:, user:)
        end.to raise_error(Auth::Errors::AuthenticationError, 'Refresh Token does not exist.')
      end

      it 'refresh_token expired' do
        refresh_token = create(:refresh_token, user:,
                                               access_token_jti: decoded_token[:jti],
                                               exp: Time.now.utc - 2.days)

        expect do
          refresher.refresh!(refresh_token:, decoded_token:, user:)
        end.to raise_error(Auth::Errors::AuthenticationError, 'Refresh Token expired.')

        expect(user.refresh_tokens).to be_empty
      end
    end
  end
end
