# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate!, only: %i[signin signup]

  def check
    render current_user.present? ? Responder.ok : Responder.unauthorized
  end

  def refresh
    refresh_token = cookies.signed[:refresh_token]

    refresh_tokens(refresh_token:, decoded_token:, user: current_user)

    render Responder.ok(msg: 'Token refreshed.')
  end

  def signin
    email, password = params.require(%i[email password])

    user = User.find_by(email:)
    if user&.authenticate(password)
      issue_tokens(user:)

      return render Responder.created(data: user_response(user:), msg: 'Signin success.')
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
    ActiveRecord::Base.transaction do
      email, password, username = params.require(%i[email password username])
      avatar = params['avatar']

      if User.find_by(email:).present?
        render Responder.unprocessable(msg: 'Unable to create User.', errors: ['Email has already been taken.'])
      else
        user = User.new(email:, password:)

        if user.save
          profile = Profile.new(user:, username:)
          profile.avatar.attach(avatar) if avatar.present?

          if profile.save
            issue_tokens(user:)

            render Responder.created(msg: 'Signup Success.', data: user_response(user:))
          else
            render Responder.unprocessable(msg: 'Unable to create Profile.',
                                           errors: [profile.errors.full_messages.to_sentence])
            raise ActiveRecord::Rollback
          end
        else
          render Responder.unprocessable(msg: 'Unable to create User.', errors: [user.errors.full_messages.to_sentence])
        end
      end
    end
  end

  private

  def params
    super.permit(:email, :password, :username, :avatar)
  end

  def issue_tokens(user:)
    access_token, refresh_token = Auth::Issuer.issue!(user)
    cookies.signed[:access_token] = { value: access_token, httponly: true }
    cookies.signed[:refresh_token] = { value: refresh_token, httponly: true, path: '/auth' }
  end

  def refresh_tokens(refresh_token:, decoded_token:, user:)
    new_access_token, new_refresh_token = Auth::Refresher.refresh!(refresh_token:, decoded_token:, user:)
    cookies.signed[:access_token] = { value: new_access_token, httponly: true }
    cookies.signed[:refresh_token] = { value: new_refresh_token, httponly: true, path: '/auth' }
  end

  def user_response(user:)
    profile = user.profile
    profile_info = {
      username: profile.username,
      avatar: profile.avatar.attached? ? url_for(profile.avatar) : nil
    }

    user.slice(:id, :uuid, :email).merge(profile_info).compact
  end
end
