# frozen_string_literal: true

module Auth
  module Encoder
    module_function

    def encode!(user)
      jti = SecureRandom.hex
      iat, exp = token_expiry
      access_token = JWT.encode(
        { user_id: user.id, jti:, iat:, exp: },
        Auth::Secret.secret
      )

      [access_token, jti, exp, iat]
    rescue StandardError => e
      raise Errors::EncodeError, e.message
    end

    private_class_method def token_expiry
      time = Time.now.utc
      [time.to_i, (time + Auth::Expiry.access_token_span).to_i]
    end
  end
end
