# frozen_string_literal: true

module Auth
  module Revoker
    module_function

    def revoke!(decoded_token:, user:)
      jti = decoded_token.fetch(:jti)
      exp = decoded_token.fetch(:exp)

      Auth::Whitelister.remove_whitelist!(jti:)
      Auth::Blacklister.blacklist!(
        jti:,
        exp:,
        user:
      )
    rescue StandardError => e
      raise Errors::RevokeError, e.message
    end
  end
end
