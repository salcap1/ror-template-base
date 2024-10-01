# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_many(:refresh_tokens) }
    it { is_expected.to have_many(:whitelisted_tokens) }
    it { is_expected.to have_many(:blacklisted_tokens) }
  end

  describe 'validations' do
    subject { create(:user) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'database' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:uuid) }
    it { is_expected.to have_db_column(:email) }
    it { is_expected.to have_db_column(:password_digest) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
  end
end
