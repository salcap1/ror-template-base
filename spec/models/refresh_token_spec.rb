# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshToken do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:refresh_token) }

    it { is_expected.to validate_presence_of(:access_token_jti) }
    it { is_expected.to validate_presence_of(:exp) }
  end

  describe 'database' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:access_token_jti) }
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:exp) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
  end
end
