# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'validations' do
    subject { create(:profile) }

    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
  end

  describe 'database' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:username) }
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
  end
end
