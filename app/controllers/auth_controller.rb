# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate!, only: %i[signin signup]

  def check
    render_success(data: current_user, message: 'User logged in.')
  end

  def refresh
    refresh_token = cookies.signed[:refresh_token]

    refresh_tokens(refresh_token:, decoded_token:, user: current_user)

    render_success(message: 'Token refreshed.')
  end

  def signin
    email, password = params.require(%i[email password])

    user = User.find_by(email:)
    return render_error(message: 'Signin failed.') unless user&.authenticate(password)

    issue_tokens(user:)

    render_success(data: user_response(user:), message: 'Signin success.', status: :created)
  end

  def signout
    Auth::Revoker.revoke!(decoded_token:, user: current_user)

    cookies.delete(:access_token)
    cookies.delete(:refresh_token, { path: '/auth' })

    render_success(msg: 'Signout Success.', status: :no_content)
  end

  def signup
    ActiveRecord::Base.transaction do
      email, password, username = params.require(%i[email password username])
      avatar = params[:avatar]

      if User.find_by(email:).present?
        render_error(message: 'Unable to create User.', errors: ['Email has already been taken.'])
      else
        user = User.new(email:, password:)

        if user.save
          profile = Profile.new(user:, username:)
          profile.avatar.attach(avatar) if avatar.present?

          if profile.save
            issue_tokens(user:)

            render_success(message: 'Signup Success.', data: user_response(user:), status: :created)
          else
            render_error(message: 'Unable to create Profile.', errors: [profile.errors.full_messages.to_sentence])
            raise ActiveRecord::Rollback
          end
        else
          render_error(message: 'Unable to create User.', errors: [user.errors.full_messages.to_sentence])
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
