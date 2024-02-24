# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  before_save :generate_uuid

  has_many :refresh_tokens, dependent: :delete_all
  has_many :whitelisted_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  validates :email, uniqueness: { case_insensitive: true }
  validates :username, uniqueness: { case_insensitive: true }

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
