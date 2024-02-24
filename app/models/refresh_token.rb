# frozen_string_literal: true

class RefreshToken < ApplicationRecord
  belongs_to :user

  validates :access_token_jti, :exp, presence: true
end
