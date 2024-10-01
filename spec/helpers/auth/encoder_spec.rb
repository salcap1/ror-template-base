# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Encoder do
  let!(:encoder) { subject }

  let!(:user) { create(:user) }
  let!(:access_token) { Faker::Internet.device_token }

  describe '#decode!' do
    describe 'success' do
      time = Time.now.utc
      jti = 'e0d1c3f05b64ca3b24382f84f421b022'

      before do
        allow(JWT).to receive(:encode).and_return(access_token)
        allow(Time).to receive_message_chain(:now, :utc).and_return(time) # rubocop:disable RSpec/MessageChain
        allow(SecureRandom).to receive(:hex).and_return(jti)
      end

      it 'creates token' do
        expect(encoder.encode!(user)).to eq [
          access_token,
          jti,
          (time + Auth::Expiry.access_token_span).to_i,
          time.to_i
        ]
      end
    end

    describe 'failure' do
      it 'to create token' do
        allow(JWT).to receive(:encode).and_raise(StandardError, 'Encode Error.')

        expect do
          encoder.encode!(user)
        end.to raise_error(Auth::Errors::EncodeError, 'Encode Error.')
      end
    end
  end
end
