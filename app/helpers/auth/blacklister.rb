# frozen_string_literal: true

module Auth
  module Blacklister
    module_function

    def blacklist!(jti:, exp:, user:)
      user.blacklisted_tokens.create!({ jti:, exp: Time.at(exp).utc })
    rescue StandardError => e
      raise Errors::BlacklistError, e.message
    end

    def blacklisted?(jti:)
      BlacklistedToken.exists?(jti:)
    end
  end
end
