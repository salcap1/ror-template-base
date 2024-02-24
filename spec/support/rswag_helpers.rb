# frozen_string_literal: true

module RswagHelpers
  def response_data(response)
    JSON.parse(response.body)['data']
  end

  def response_errors(response)
    JSON.parse(response.body)['errors']
  end
end
