# frozen_string_literal: true

module Auth
  module Whitelister
    module_function

    def whitelist!(jti:, exp:, user:)
      user.whitelisted_tokens.create!(jti:, exp: Time.zone.at(exp))
    rescue StandardError => e
      raise Errors::WhitelistError, e.message
    end

    def remove_whitelist!(jti:)
      whitelist = WhitelistedToken.find_by(
        jti:
      )
      whitelist.destroy if whitelist.present?
    end

    def whitelisted?(jti:)
      WhitelistedToken.exists?(jti:)
    end
  end
end
