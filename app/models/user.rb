# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  before_save :generate_uuid

  has_one :profile, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy
  has_many :whitelisted_tokens, dependent: :destroy
  has_many :blacklisted_tokens, dependent: :destroy

  validates :email, uniqueness: { case_insensitive: true }

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
