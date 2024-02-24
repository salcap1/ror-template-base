# frozen_string_literal: true

module Auth
  module Decoder
    module_function

    def decode!(access_token, verify: true)
      decoded = JWT.decode(access_token, Auth::Secret.secret, verify, verify_iat: true)[0]
      decoded.symbolize_keys
    rescue StandardError => e
      raise Errors::DecodeError, e.message
    end
  end
end
