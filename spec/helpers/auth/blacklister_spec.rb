# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Blacklister do
  let!(:blacklister) { subject }

  let!(:user) { create(:user) }
  let!(:jti) { Faker::Internet.device_token }
  let!(:exp) { Time.now.utc + 10.days }

  describe '#blacklist!' do
    describe 'success' do
      it 'creates token' do
        blacklister.blacklist!(jti:, exp:, user:)

        expect(BlacklistedToken.first.user).to eq user
      end
    end

    describe 'failure' do
      it 'to create token' do
        expect do
          blacklister.blacklist!(jti: nil, exp: nil, user: nil)
        end.to raise_error(Auth::Errors::BlacklistError)
      end
    end
  end

  describe '#blacklisted?' do
    it 'token is blacklisted' do
      blacklister.blacklist!(jti:, exp:, user:)

      expect(blacklister.blacklisted?(jti:)).to be true
    end

    it 'token is not blacklisted' do
      expect(blacklister.blacklisted?(jti: Faker::Internet.device_token)).to be false
    end
  end
end
