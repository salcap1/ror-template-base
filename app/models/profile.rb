# frozen_string_literal: true

class Profile < ApplicationRecord
  has_one_attached :avatar

  belongs_to :user

  validates :username, uniqueness: { case_insensitive: true }
  validate :acceptable_image

  def acceptable_image
    return unless avatar.attached?

    errors.add(:avatar, 'is too big') unless avatar.blob.byte_size <= 1.megabyte

    acceptable_types = ['image/jpeg', 'image/png']
    return if acceptable_types.include?(avatar.content_type)

    errors.add(:avatar, 'must be a JPEG or PNG')
  end
end
