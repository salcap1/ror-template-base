# frozen_string_literal: true

module Auth
  module Expiry
    module_function

    def access_token_span
      15.minutes # TODO: Make ENV_VAR
    end

    def refresh_token_span
      24.hours # TODO: Make ENV_VAR
    end

    def expired?(token:)
      Time.now.utc.after?(token.exp)
    end
  end
end
