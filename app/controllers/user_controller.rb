# frozen_string_literal: true

class UserController < ApplicationController
  def delete
    current_user.destroy

    render Responder.no_content(msg: 'Success')
  rescue StandardError => e
    render Responder.unprocessable(data: current_user, errors: [e.message])
  end
end
