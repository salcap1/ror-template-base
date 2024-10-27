# frozen_string_literal: true

class UserController < ApplicationController
  def delete
    current_user.destroy!

    render_success(status: :no_content)
  end
end
