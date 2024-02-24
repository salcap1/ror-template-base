# frozen_string_literal: true

module Auth
  module Authenticator
    module_function

    def authenticate!(access_token:)
      raise Errors::AuthenticationError, 'Token is blank.' if access_token.blank?

      decoded_token = decode_token(access_token)
      jti, user_id = decoded_token.fetch_values(:jti, :user_id)
      user = User.find_by(id: user_id)

      raise Errors::AuthenticationError, 'No matching User for token.' if user.blank?

      is_blacklisted, is_whitelisted = permissions(jti)

      raise Errors::AuthenticationError, 'Token is blacklisted.' if is_blacklisted
      raise Errors::AuthenticationError, 'Token is not whitelisted.' unless is_whitelisted

      [user, decoded_token]
    end

    private_class_method def decode_token(access_token)
      Auth::Decoder.decode!(access_token)
    end

    private_class_method def permissions(jti)
      [Auth::Blacklister.blacklisted?(jti:), Auth::Whitelister.whitelisted?(jti:)]
    end
  end
end
