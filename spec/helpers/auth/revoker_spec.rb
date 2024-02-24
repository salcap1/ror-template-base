# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Revoker do
  let!(:revoker) { subject }

  let!(:user) { create(:user) }

  describe '#revoke!' do
    describe 'success' do
      let(:decoded_token) { { jti: Faker::Internet.device_token, exp: Time.now.utc, user_id: user.id } }

      it 'revokes token' do
        create(:whitelisted_token, user:, jti: decoded_token[:jti])

        revoker.revoke!(decoded_token:, user:)

        expect(Auth::Whitelister.whitelisted?(jti: decoded_token[:jti])).to be false
        expect(Auth::Blacklister.blacklisted?(jti: decoded_token[:jti])).to be true
      end
    end

    describe 'failure' do
      let(:decoded_token) { {} }

      it 'to revoke token' do
        expect do
          revoker.revoke!(decoded_token:, user:)
        end.to raise_error(Auth::Errors::RevokeError)
      end
    end
  end
end
