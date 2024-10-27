# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Secured

  skip_before_action :authenticate!, only: %i[index heartbeat error]

  class UnauthorizedError < StandardError; end

  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from Auth::Errors::AuthenticationError, with: :handle_unauthorized

  # Index endpoint (can be customized to show app info or available routes)
  def index
    render_success(data: { message: 'Welcome to the API', version: '1.0.0' }, message: 'API Index')
  end

  # Health check endpoint (simple heartbeat)
  def heartbeat
    render_success(message: 'API is live')
  end

  # Custom error endpoint for rendering an error page
  def error
    render_error(message: 'Something went wrong. Please try again later.')
  end

  # Success Response Formatter
  def render_success(data: {}, message: 'Success', status: :ok)
    render json: {
      status: 'success',
      message:,
      data:
    }, status:
  end

  # Error Response Formatter
  def render_error(errors: [], message: 'Error', status: :unprocessable_entity)
    render json: {
      status: 'error',
      message:,
      errors:
    }, status:
  end

  private

  # Handle Invalid Record Error
  def handle_record_invalid(exception)
    render_error(
      errors: exception.record.errors.full_messages,
      message: 'Validation failed.',
      status: :unprocessable_entity
    )
  end

  # Handle Record Not Found Error
  def handle_record_not_found(exception)
    render_error(
      message: 'Record not found.',
      errors: [exception.message],
      status: :not_found
    )
  end

  # Handle Missing Parameters
  def handle_parameter_missing(exception)
    render_error(
      message: 'Missing required parameters.',
      errors: [exception.message],
      status: :bad_request
    )
  end

  # Handle Unauthorized Access
  def handle_unauthorized(exception = nil)
    render_error(
      message: 'Unauthorized access.',
      errors: [exception&.message || 'You need to log in to perform this action'],
      status: :unauthorized
    )
  end
end
