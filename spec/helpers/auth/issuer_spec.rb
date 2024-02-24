# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Issuer do
  let!(:issuer) { subject }

  let!(:user) { create(:user) }

  describe '#issue!' do
    describe 'success' do
      it 'tokens issued' do
        access_token = Faker::Internet.device_token
        jti = Faker::Internet.device_token
        exp = Time.now.utc.to_i + 15.minutes
        iat = Time.now.utc.to_i

        allow(Auth::Encoder)
          .to receive(:encode!)
          .and_return(
            [access_token, jti, exp, iat]
          )

        issuer.issue!(user)

        refresh_token = user.refresh_tokens.first
        expect(refresh_token.access_token_jti).to eq jti

        whitelisted_token = user.whitelisted_tokens.first
        expect(Auth::Whitelister.whitelisted?(jti: whitelisted_token.jti)).to be true
        expect(whitelisted_token.jti).to eq jti
        expect(whitelisted_token.exp.to_i).to eq exp
      end
    end

    describe 'failure' do
      it 'to issue tokens' do
        allow(Auth::Encoder)
          .to receive(:encode!)
          .and_raise(StandardError, 'Issue Error.')

        expect do
          issuer.issue!(user)
        end.to raise_error(Auth::Errors::IssueError, 'Issue Error.')
      end
    end
  end
end
