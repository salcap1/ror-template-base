# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::Secret do
  let!(:secreter) { subject }

  describe '#secret' do
    it 'returns value' do
      expect(secreter.secret).to eq Rails.application.secrets.secret_key_base
    end
  end
end
