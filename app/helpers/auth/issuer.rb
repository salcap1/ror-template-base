# frozen_string_literal: true

module Auth
  module Issuer
    module_function

    def issue!(user)
      access_token, jti, exp, iat = Auth::Encoder.encode!(user)
      refresh_exp = Time.at(iat + Auth::Expiry.refresh_token_span).utc
      refresh_token = user.refresh_tokens.create!(access_token_jti: jti, exp: refresh_exp)

      Auth::Whitelister.whitelist!(jti:, exp:, user:)

      [access_token, refresh_token]
    rescue StandardError => e
      raise Errors::IssueError, e.message
    end
  end
end
