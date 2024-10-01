# frozen_string_literal: true

module Responder
  class << self
    def ok(data: nil, msg: 'Success', **)
      default(data, msg, :ok, **)
    end

    def created(data: nil, msg: 'Created', **)
      default(data, msg, :created, **)
    end

    def not_found(data: nil, msg: 'Not Found', **)
      default(data, msg, :not_found, **)
    end

    def bad_request(data: nil, msg: 'Bad Request', **)
      default(data, msg, :bad_request, **)
    end

    def unprocessable(data: nil, msg: 'Unprocessable', **)
      default(data, msg, :unprocessable_entity, **)
    end

    def no_content(data: nil, msg: 'Deleted', **)
      default(data, msg, :no_content, **)
    end

    def unauthorized(data: nil, msg: 'Unauthorized', **)
      default(data, msg, :unauthorized, **)
    end

    private

    def default(data, msg, code, **)
      { json: { message: msg, data:, ** }.compact, status: code }
    end
  end
end
