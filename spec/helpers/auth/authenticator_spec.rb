# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Authenticator do
  describe '#authenticate!' do
    let!(:authenticator) { subject }
    let!(:user) { create(:user) }
    let!(:access_token) { Faker::Internet.device_token }
    let!(:decoded_token) { { jti: Faker::Internet.device_token, user_id: user.id } }

    describe 'success' do
      it 'returns user & token' do
        allow(Auth::Decoder).to receive(:decode!).with(access_token).and_return(decoded_token)
        allow(Auth::Blacklister).to receive(:blacklisted?).and_return(false)
        allow(Auth::Whitelister).to receive(:whitelisted?).and_return(true)

        expect(authenticator.authenticate!(access_token:)).to eq [user, decoded_token]
      end
    end

    describe 'failure' do
      it 'token is empty' do
        expect do
          authenticator.authenticate!(access_token: nil)
        end.to raise_error(Auth::Errors::AuthenticationError, 'Token is blank.')
      end

      it 'token is invalid' do
        allow(Auth::Decoder).to receive(:decode!).with(access_token).and_raise(Auth::Errors::DecodeError)

        expect do
          authenticator.authenticate!(access_token:)
        end.to raise_error(Auth::Errors::DecodeError)
      end

      it 'user does not exist' do
        allow(User).to receive(:find_by).and_return(nil)
        allow(Auth::Decoder).to receive(:decode!).with(access_token).and_return(decoded_token)

        expect do
          authenticator.authenticate!(access_token:)
        end.to raise_error(Auth::Errors::AuthenticationError, 'No matching User for token.')
      end

      it 'token is blacklisted' do
        allow(Auth::Decoder).to receive(:decode!).with(access_token).and_return(decoded_token)
        allow(Auth::Blacklister).to receive(:blacklisted?).and_return(true)
        allow(Auth::Whitelister).to receive(:whitelisted?).and_return(true)

        expect do
          authenticator.authenticate!(access_token:)
        end.to raise_error(Auth::Errors::AuthenticationError, 'Token is blacklisted.')
      end

      it 'token is not whitelisted' do
        allow(Auth::Decoder).to receive(:decode!).with(access_token).and_return(decoded_token)
        allow(Auth::Blacklister).to receive(:blacklisted?).and_return(false)
        allow(Auth::Whitelister).to receive(:whitelisted?).and_return(false)

        expect do
          authenticator.authenticate!(access_token:)
        end.to raise_error(Auth::Errors::AuthenticationError, 'Token is not whitelisted.')
      end
    end
  end
end
