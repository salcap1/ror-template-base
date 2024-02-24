# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Whitelister do
  let!(:whitelister) { subject }

  let!(:user) { create(:user) }
  let!(:jti) { Faker::Internet.device_token }
  let!(:exp) { Time.now.utc + 10.days }

  describe '#whitelist!' do
    describe 'success' do
      it 'creates token' do
        whitelister.whitelist!(jti:, exp:, user:)

        expect(WhitelistedToken.first.user).to eq user
      end
    end

    describe 'failure' do
      it 'to create token' do
        expect do
          whitelister.whitelist!(jti: nil, exp: nil, user: nil)
        end.to raise_error(Auth::Errors::WhitelistError)
      end
    end
  end

  describe '#remove_whitelist!' do
    describe 'success' do
      it 'creates token' do
        whitelister.whitelist!(jti:, exp:, user:)

        expect(WhitelistedToken.find_by(jti:)).to be_present

        whitelister.remove_whitelist!(jti:)

        expect(WhitelistedToken.find_by(jti:)).not_to be_present
      end
    end
  end

  describe '#whitelisted?' do
    it 'token is whitelisted' do
      whitelister.whitelist!(jti:, exp:, user:)

      expect(whitelister.whitelisted?(jti:)).to be true
    end

    it 'token is not whitelisted' do
      expect(whitelister.whitelisted?(jti: Faker::Internet.device_token)).to be false
    end
  end
end
