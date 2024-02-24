# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Expiry do
  let!(:expirer) { subject }

  describe '#access_token_span' do
    it 'returns value' do
      expect(expirer.access_token_span).to eq 15.minutes
    end
  end

  describe '#refresh_token_span' do
    it 'returns value' do
      expect(expirer.refresh_token_span).to eq 24.hours
    end
  end

  describe '#expired?' do
    it 'is not expired' do
      token = create(:whitelisted_token)

      expect(expirer.expired?(token:)).to be false
    end

    it 'is expired' do
      token = create(:whitelisted_token, exp: Time.now.utc - 1.minute)

      expect(expirer.expired?(token:)).to be true
    end
  end
end
