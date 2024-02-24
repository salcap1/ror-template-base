# frozen_string_literal: true

class BlacklistedToken < ApplicationRecord
  belongs_to :user

  validates :jti, :exp, presence: true
end
