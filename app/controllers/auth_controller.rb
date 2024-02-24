# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate!, only: %i[signin signup]

  def check
    render current_user.present? ? Responder.ok : Responder.unauthorized
  end

  def refresh
    raise Auth::Errors::AuthenticationError, 'User not logged in.' if current_user.blank?

    refresh_token = cookies.signed[:refresh_token]

    new_access_token, new_refresh_token = Auth::Refresher.refresh!(refresh_token:, decoded_token:, user: current_user)
    issue_tokens(access_token: new_access_token, refresh_token: new_refresh_token)

    render Responder.ok(msg: 'Token refreshed.')
  end

  def signin
    email, password = params.require(%i[email password])

    user = User.find_by(email:)
    if user&.authenticate(password)
      access_token, refresh_token = Auth::Issuer.issue!(user)
      issue_tokens(access_token:, refresh_token:)

      data = user.slice(:id, :uuid, :email, :username)
      return render Responder.created(data:, msg: 'Signin success.')
    end

    render Responder.unprocessable(msg: 'Signin failed.', errors: ['Email address or password is invalid.'])
  end

  def signout
    Auth::Revoker.revoke!(decoded_token:, user: current_user)

    cookies.delete(:access_token)
    cookies.delete(:refresh_token, { path: '/auth' })

    render Responder.no_content(msg: 'Signout Success.')
  end

  def signup
    email, password, username = params.require(%i[email password username])

    user = User.create(email:, password:, username:)

    if user.persisted?
      access_token, refresh_token = Auth::Issuer.issue!(user)
      issue_tokens(access_token:, refresh_token:)

      data = user.slice(:id, :uuid, :email, :username)
      render Responder.created(data:, msg: 'Signup Success.')
    else
      render Responder.unprocessable(msg: 'User not created.', errors: [user.errors.full_messages.to_sentence])
    end
  end

  private

  def issue_tokens(access_token:, refresh_token:)
    cookies.signed[:access_token] = { value: access_token, httponly: true }
    cookies.signed[:refresh_token] = { value: refresh_token, httponly: true, path: '/auth' }
  end
end
