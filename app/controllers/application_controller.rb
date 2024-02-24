# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Secured

  skip_before_action :authenticate!, only: %i[index heartbeat error]

  rescue_from ActionController::ParameterMissing do |e|
    render Responder.bad_request(errors: [e.original_message])
  end

  def index
    render Responder.ok
  end

  def heartbeat
    render Responder.ok(msg: 'healthy')
  end

  def error
    render Responder.not_found(msg: 'error')
  end

  protected

  def params
    ActionController::Parameters.new(
      super.to_unsafe_h.deep_transform_keys!(&:underscore)
    )
  end
end
