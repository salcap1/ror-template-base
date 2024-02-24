# frozen_string_literal: true

module Auth
  module Errors
    class AuthenticationError < StandardError; end

    class BlacklistError < AuthenticationError; end
    class DecodeError < AuthenticationError; end
    class EncodeError < AuthenticationError; end
    class IssueError < AuthenticationError; end
    class RefreshError < AuthenticationError; end
    class RevokeError < AuthenticationError; end
    class WhitelistError < AuthenticationError; end
  end
end
