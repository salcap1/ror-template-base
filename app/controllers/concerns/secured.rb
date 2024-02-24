# frozen_string_literal: true

module Secured
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user, :decoded_token

    before_action :authenticate!

    rescue_from Auth::Errors::AuthenticationError do |e|
      render Responder.unauthorized(errors: [e.message])
    end

    private

    def authenticate!
      current_user, decoded_token = Auth::Authenticator.authenticate!(
        access_token: cookies.signed[:access_token]
      )

      @current_user = current_user
      @decoded_token = decoded_token
    end
  end
end
