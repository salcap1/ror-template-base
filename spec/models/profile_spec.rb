# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'validations' do
    subject(:profile) { create(:profile) }

    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    context 'when avatar is attached' do
      before do
        profile.avatar.attach(io: Rails.root.join('spec/fixtures/files/avatar.jpg').open,
                              filename: 'valid_image.jpg', content_type: 'image/jpeg')
      end

      it 'is valid with a JPEG image under 1MB' do
        expect(profile).to be_valid
      end

      it 'is invalid when the image exceeds 1MB' do
        profile.avatar.attach(io: Rails.root.join('spec/fixtures/files/nova-large.jpg').open,
                              filename: 'nova-large.jpg', content_type: 'image/jpeg')

        profile.valid?
        expect(profile.errors[:avatar]).to include('is too big')
      end

      it 'is invalid with a non-JPEG/PNG image type' do
        profile.avatar.attach(io: Rails.root.join('spec/fixtures/files/nova.mov').open,
                              filename: 'nova.mov', content_type: 'video/quicktime')

        profile.valid?
        expect(profile.errors[:avatar]).to include('must be a JPEG or PNG')
      end
    end
  end

  describe 'database' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:username) }
    it { is_expected.to have_db_column(:user_id) }
    it { is_expected.to have_db_column(:created_at) }
    it { is_expected.to have_db_column(:updated_at) }
  end
end
