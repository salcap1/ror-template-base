# frozen_string_literal: true

module Auth
  module Refresher
    module_function

    def refresh!(refresh_token:, decoded_token:, user:)
      if refresh_token.blank? || decoded_token.blank? || user.blank?
        raise Errors::AuthenticationError, 'Missing arguments.'
      end

      jti, exp, existing_refresh_token = find_existing_refresh_token(decoded_token, user)

      raise Errors::AuthenticationError, 'Refresh Token does not exist.' if existing_refresh_token.blank?

      check_expired(existing_refresh_token)

      update_permissions(jti, exp, user)

      issue_tokens(user, existing_refresh_token)
    rescue StandardError => e
      raise Errors::RefreshError, e.message
    end

    private_class_method def find_existing_refresh_token(decoded_token, user)
      jti, exp = decoded_token.fetch_values(:jti, :exp)
      exisiting_refresh_token = user.refresh_tokens.find_by(access_token_jti: jti)
      [jti, exp, exisiting_refresh_token]
    end

    private_class_method def check_expired(existing_refresh_token)
      return unless Auth::Expiry.expired?(token: existing_refresh_token)

      existing_refresh_token.destroy!

      raise Errors::AuthenticationError, 'Refresh Token expired.'
    end

    private_class_method def issue_tokens(user, existing_refresh_token)
      existing_refresh_token.destroy!
      Auth::Issuer.issue!(user)
    end

    private_class_method def update_permissions(jti, exp, user)
      Auth::Blacklister.blacklist!(jti:, exp:, user:)
      Auth::Whitelister.remove_whitelist!(jti:)
    end
  end
end
