# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Decoder do
  let!(:decoder) { subject }

  let!(:access_token) { Faker::Internet.device_token }

  describe '#decode!' do
    describe 'success' do
      it 'creates token' do
        decoded_token = [{ key1: 'data1', key2: 'data2' }]

        allow(JWT).to receive(:decode).and_return(decoded_token)

        expect(decoder.decode!(access_token)).to eq decoded_token[0].symbolize_keys
      end
    end

    describe 'failure' do
      it 'to create token' do
        allow(JWT).to receive(:decode).and_raise(StandardError, 'Decode Error.')

        expect do
          decoder.decode!(access_token)
        end.to raise_error(Auth::Errors::DecodeError, 'Decode Error.')
      end
    end
  end
end
